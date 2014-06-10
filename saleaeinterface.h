#ifndef __SALEAE_INTERFACE_XS_H__
#define __SALEAE_INTERFACE_XS_H__

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef struct {
    enum {
        UNKNOWN,
        LOGIC,
        LOGIC16 
    } itype;
    void *ptr;
} saleaeinterface_t;

saleaeinterface_t *saleaeinterface_new();
void saleaeinterface_DESTROY(saleaeinterface_t *obj);
void saleaeinterface_begin_connect();
void saleaeinterface_register_on_connect(saleaeinterface_t *obj);
void saleaeinterface_register_on_disconnect(saleaeinterface_t *obj);
void saleaeinterface_register_on_readdata(saleaeinterface_t *obj);
void saleaeinterface_register_on_writedata(saleaeinterface_t *obj);
void saleaeinterface_register_on_error(saleaeinterface_t *obj);

#ifdef __cplusplus
} /* extern C end */
#endif /* __cplusplus */

#endif /* __SALEAE_INTERFACE_XS_H__ */
