#ifndef __SALEAE_INTERFACE_XS_H__
#define __SALEAE_INTERFACE_XS_H__

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

enum {
    SALEAEINTERFACE_UNKNOWN = 0,
    SALEAEINTERFACE_LOGIC,
    SALEAEINTERFACE_LOGIC16
};

typedef struct {
    unsigned int itype;
    unsigned int begun;
    /* these are all SV* objects */
    void *parent;
    void *on_connect;
    void *on_disconnect;
    void *on_readdata;
    void *on_writedata;
    void *on_error;
    /* these are SaleaeDeviceAPI objects */
    unsigned long long int device_id;
    void *interface;
} saleaeinterface_t;

void saleaeinterface_begin_connect(saleaeinterface_t *obj);
void saleaeinterface_internal_on_connect(saleaeinterface_t *obj);
void saleaeinterface_internal_on_disconnect(saleaeinterface_t *obj);
void saleaeinterface_internal_on_error(saleaeinterface_t *obj);
void saleaeinterface_internal_on_readdata(saleaeinterface_t *obj,
                    unsigned char *data, unsigned int len);
void saleaeinterface_internal_on_writedata(saleaeinterface_t *obj,
                    unsigned char *data, unsigned int len);

#ifdef __cplusplus
} /* extern C end */
#endif /* __cplusplus */

#endif /* __SALEAE_INTERFACE_XS_H__ */
