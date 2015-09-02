#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include <sys/time.h>

#include "wilddog.h"
#include "wilddog_debug.h"
#include "demo.h"

#define JSON_BUFF_LEN 8192
#define MAX_RETRY_SETVAL 3 // three times 
int loop;
char json_buff[ JSON_BUFF_LEN ];
struct timeval tv;

void (*newlisp_process_json)(void);

typedef struct _guu_is_wilddog_t{
	Wilddog_T wd;
	BOOL observer_finished;
	BOOL setvalue_finished;
	
	Wilddog_Node_T *snapshot_clone;	
	int count;
	int set_value_retry;
	Wilddog_Str_T *node_val;

	void (*observer_cb)( const Wilddog_Node_T* p_snapshot,  void* arg,Wilddog_Return_T err);

	struct _guu_is_wilddog_t *next;

}guu_is_wilddog_t;

/*Func declare*/
void setvalue_cb(void* arg, Wilddog_Return_T err);
/**/
// in Observer_CB directly send response data bask to wilddog
// IO operation hardly to be error
char* json_buff_addr()
{
	return json_buff;
}

void set_loop(int n) // for newlisp to break the loop
{
	loop = n;
}

void set_receive_time(guu_is_wilddog_t *gwd)
{
	//set the unix time stamp in the tree we got
	char time_buf[14];
	int len;
	
	Wilddog_Node_T *node;
	
	node = wilddog_node_find(gwd->snapshot_clone,"received");
	if(node !=NULL)
	{
		gettimeofday(&tv, NULL);

		len = sprintf(time_buf,"%ld", tv.tv_sec);
		//printf("%s %d\n",time_buf,len);
		if( wilddog_node_setValue(node,time_buf,len) != 0)
		{
			wilddog_debug("setValue failed\n");
		}

	}
	

	wilddog_setValue(gwd->wd,gwd->snapshot_clone,setvalue_cb,(void*)gwd);

}

void setvalue_cb(void* arg, Wilddog_Return_T err)
{
		guu_is_wilddog_t *ptr_gwd;
		ptr_gwd = (guu_is_wilddog_t*)arg;
		
		ptr_gwd->setvalue_finished = TRUE;
		if(ptr_gwd->snapshot_clone !=NULL)
		{
			wilddog_node_delete(ptr_gwd->snapshot_clone);
			ptr_gwd->snapshot_clone = NULL;
		}

    if(err < WILDDOG_HTTP_OK || err >= WILDDOG_HTTP_NOT_MODIFIED)
    {
				
        wilddog_debug("set error!");
        return;
    }
    return;
}


void Observer_CB( const Wilddog_Node_T* p_snapshot,  void* arg,Wilddog_Return_T err)
{
		guu_is_wilddog_t *ptr_gwd;

	  ptr_gwd = (guu_is_wilddog_t*)arg;

		ptr_gwd->observer_finished = TRUE;

    if(err < WILDDOG_HTTP_OK || err >= WILDDOG_HTTP_NOT_MODIFIED)
    {
        wilddog_debug("addObserver failed!");
        return;
    }
		ptr_gwd->snapshot_clone = wilddog_node_clone(p_snapshot);
		/*
		*/
   // wilddog_debug("addObserver data!");
		ptr_gwd->node_val = wilddog_debug_n2jsonString(p_snapshot);
		//printf("%s\n",ptr_gwd->node_val);		
#ifdef INLISP
		if(ptr_gwd->node_val !=NULL)
		{
			strncpy(json_buff,ptr_gwd->node_val,JSON_BUFF_LEN);
			if(newlisp_process_json!=NULL)
			{
				newlisp_process_json();
			}
		}
#endif
		
		// simulate response 
		wilddog_debug_printnode(p_snapshot);
		printf("\n"); fflush(stdout);
		
		wfree(ptr_gwd->node_val);
    return;
}

//  typedef size_t Wilddog_T;
//  size_t maybe is unsgined int

Wilddog_T init_wilddog( char*url)
{
	Wilddog_T _wd;
	_wd = wilddog_initWithUrl((Wilddog_Str_T *)url);
	if(0 == _wd)
	{
		wilddog_debug("new wilddog failed! %s\n",url);
		return 0;
	}

	return _wd;
}


Wilddog_Return_T add_observer(guu_is_wilddog_t *gwd)
{
	return wilddog_addObserver(gwd->wd, WD_ET_VALUECHANGE, gwd->observer_cb, (void*)gwd); 
}

Wilddog_T  check_finished( guu_is_wilddog_t* gwd) // in a while(1) loop
{
	if(TRUE == gwd->observer_finished) 
	{
		//wilddog_debug("get new data %d times!", count++);
		gwd->observer_finished = FALSE;
		set_receive_time(gwd);
    if(gwd->count > 0)
    {
      //wilddog_debug("off the data!");
      wilddog_removeObserver(gwd->wd, WD_ET_VALUECHANGE);                                 
      return 0;
    }
  }

	if(TRUE == gwd->setvalue_finished)
	{
		gwd->setvalue_finished = FALSE;
		wilddog_debug("set success");
	}
	return 1;
}

Wilddog_Return_T wilddog_close( guu_is_wilddog_t*gwd)
{
	return wilddog_destroy(&gwd->wd);
}

void sync_wilddog()
{
	return wilddog_trySync();
}

void init_guu_wilddog_t( guu_is_wilddog_t *gwd)
{
	gwd->observer_cb = Observer_CB;
	
	gwd->count = 0;

	gwd->set_value_retry = 0;

	gwd->next = NULL;

	gwd->observer_finished = FALSE;
	
	gwd->snapshot_clone = NULL;
}

void set_newlisp_cb(void*cb)
{
	newlisp_process_json = cb;
}

void newlisp_init_wilddog(char*url)
{
	guu_is_wilddog_t gwd;
  init_guu_wilddog_t(&gwd);
  gwd.wd = init_wilddog(url);
  add_observer(&gwd);
	loop =1;
  while(loop == 1)
  {
    check_finished(&gwd);
    wilddog_trySync();
  }

  wilddog_close(&gwd);
}




#ifndef SHARE

int main(int argc, char **argv)
{
    int opt;
    char url[1024];
   	
		guu_is_wilddog_t gwd; 
    memset( url, 0, sizeof(url));


    while ((opt = getopt(argc, argv, "hl:")) != -1) 
    {
        switch (opt) 
        {
		case 'h':
			fprintf(stderr, "Usage: %s  -l url\n",
		           argv[0]);
			return 0;
		case 'l':
			strcpy(url, (const char*)optarg);
			break;			
		default: /* '?' */
			fprintf(stderr, "Usage: %s  -l url\n",
		           argv[0]);
			return 0;
        }
    }

    if( argc <3 )
    {
        printf("Usage: %s  -l url\n", argv[0]);
        return 0;
    }

		init_guu_wilddog_t(&gwd);
    gwd.wd = init_wilddog(url);
		add_observer(&gwd);		

    while(1)
    {
      check_finished(&gwd); 
			wilddog_trySync();
    }

   	wilddog_close(&gwd); 
    return 0;
}

#endif
