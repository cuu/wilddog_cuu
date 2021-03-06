
NAME := App_wiced_$(RTOS)_$(NETWORK)
WILDDOG_TOP_DIR := ../../

#app layer protocol, such as coap
APP_PROTO_TYPE=coap
#security method, such as dtls/nosec
APP_SEC_TYPE=nosec

PORT_TYPE=wiced

GLOBAL_DEFINES += WILDDOG_PORT_TYPE_WICED
GLOBAL_INCLUDES += $(WILDDOG_TOP_DIR)/examples/wiced/

$(NAME)_INCLUDES += $(WILDDOG_TOP_DIR)/include
########example
#EXAMPLE_C:=$(wildcard $(WILDDOG_TOP_DIR)/examples/wiced/*.c)
$(NAME)_SOURCES += $(WILDDOG_TOP_DIR)/examples/wiced/demo.c \
$(WILDDOG_TOP_DIR)/examples/wiced/demo_function.c

##########platform
#PLATFORM_C:=$(wildcard $(WILDDOG_TOP_DIR)/platform/$(PORT_TYPE)/*.c)
$(NAME)_SOURCES +=  $(WILDDOG_TOP_DIR)/platform/$(PORT_TYPE)/wilddog_wiced.c
##########src
$(NAME)_INCLUDES += $(WILDDOG_TOP_DIR)/src
########networking
ifeq ($(APP_PROTO_TYPE),coap)
#COAP_C:=$(wildcard $(WILDDOG_TOP_DIR)/src/networking/$(APP_PROTO_TYPE)/*.c)
$(NAME)_SOURCES += $(WILDDOG_TOP_DIR)/src/networking/$(APP_PROTO_TYPE)/option.c \
$(WILDDOG_TOP_DIR)/src/networking/$(APP_PROTO_TYPE)/pdu.c \
$(WILDDOG_TOP_DIR)/src/networking/$(APP_PROTO_TYPE)/wilddog_conn_coap.c

$(NAME)_INCLUDES += $(WILDDOG_TOP_DIR)/src/networking/coap/
endif
######secure
$(NAME)_INCLUDES += $(WILDDOG_TOP_DIR)/src/secure/
ifeq ($(APP_SEC_TYPE),nosec)
#NOSEC_C:=$(wildcard $(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/*.c)
$(NAME)_SOURCES +=  $(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/wilddog_nosec.c
GLOBAL_DEFINES += WILDDOG_PORT=5683
else
ifeq ($(APP_SEC_TYPE),dtls)
GLOBAL_DEFINES += WILDDOG_PORT=5684
#DTLS_C:=$(wildcard $(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/*.c)
$(NAME)_SOURCES += $(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/aes.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/aesni.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/asn1parse.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/asn1write.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/base64.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/bignum.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/blowfish.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/ccm.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/certs.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/cipher.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/cipher_wrap.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/ctr_drbg.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/debug.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/dhm.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/ecdh.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/ecdsa.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/ecp.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/ecp_curves.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/entropy.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/entropy_poll.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/hmac_drbg.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/md.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/md_wrap.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/md5.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/net.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/oid.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/pem.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/pk.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/pk_wrap.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/pkcs5.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/pkcs12.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/pkparse.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/ripemd160.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/rsa.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/sha1.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/sha256.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/ssl_ciphersuites.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/ssl_cli.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/ssl_srv.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/ssl_tls.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/timing.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/wilddog_dtls.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/x509.c \
$(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/lib/x509_crt.c

$(NAME)_INCLUDES += $(WILDDOG_TOP_DIR)/src/secure/$(APP_SEC_TYPE)/inc/
endif
endif
########serialize

#CBOR_C:=$(wildcard $(WILDDOG_TOP_DIR)/src/serialize/cbor/*.c)
$(NAME)_SOURCES +=  $(WILDDOG_TOP_DIR)/src/serialize/cbor/wilddog_cbor.c
$(NAME)_INCLUDES += $(WILDDOG_TOP_DIR)/src/serialize/cbor/

##########src
#SRC_C:=$(wildcard $(WILDDOG_TOP_DIR)/src/*.c)
$(NAME)_SOURCES +=  $(WILDDOG_TOP_DIR)/src/performtest.c \
$(WILDDOG_TOP_DIR)/src/ramtest.c \
$(WILDDOG_TOP_DIR)/src/wilddog_api.c \
$(WILDDOG_TOP_DIR)/src/wilddog_common.c \
$(WILDDOG_TOP_DIR)/src/wilddog_conn.c \
$(WILDDOG_TOP_DIR)/src/wilddog_ct.c \
$(WILDDOG_TOP_DIR)/src/wilddog_debug.c \
$(WILDDOG_TOP_DIR)/src/wilddog_event.c \
$(WILDDOG_TOP_DIR)/src/wilddog_node.c \
$(WILDDOG_TOP_DIR)/src/wilddog_store.c \
$(WILDDOG_TOP_DIR)/src/wilddog_url_parser.c

#==============================================================================
# Configuration
#==============================================================================

WIFI_CONFIG_DCT_H := wifi_config_dct.h

FreeRTOS_START_STACK := 600
ThreadX_START_STACK  := 600

#==============================================================================
# Global defines
#==============================================================================
GLOBAL_DEFINES += UART_BUFFER_SIZE=128

ifeq ($(PLATFORM),$(filter $(PLATFORM), BCM94390WCD1 BCM94390WCD2 BCM94390WCD3))
GLOBAL_DEFINES += TX_PACKET_POOL_SIZE=14 RX_PACKET_POOL_SIZE=14
GLOBAL_DEFINES += PBUF_POOL_TX_SIZE=8 PBUF_POOL_RX_SIZE=8
else
ifneq ($(PLATFORM),BCM943362WCD2)
GLOBAL_DEFINES += TX_PACKET_POOL_SIZE=15 RX_PACKET_POOL_SIZE=15
GLOBAL_DEFINES += PBUF_POOL_TX_SIZE=8 PBUF_POOL_RX_SIZE=8
endif
endif
