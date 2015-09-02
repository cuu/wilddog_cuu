(constant 'sofile "./libaddobserver.so")

(import sofile "set_newlisp_cb")
(import sofile "newlisp_init_wilddog")
(import sofile "json_buff_addr")

(define (process_json)
		(println "in newlisp: " (get-string (json_buff_addr)))
)

(setq url "coap://shixun.wilddogio.com/locks")
(set 'func (callback 0 'process_json))

(set_newlisp_cb func)
(newlisp_init_wilddog url)
(println "exiting..")
(exit a)

