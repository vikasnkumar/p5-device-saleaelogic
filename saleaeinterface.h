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
    unsigned int begun;
    void *perl;
    /* these are all SV* objects */
    void *parent;
    void *on_connect;
    void *on_disconnect;
    void *on_readdata;
    void *on_writedata;
    void *on_error;
    /* these are SaleaeDeviceAPI objects */
    size_t interface_count;
    void *interface_map; /* internal object */
    void *id_map; /* internal object */
} saleaeinterface_t;

/* interface for XS to call */
void *saleaeinterface_map_create();
void saleaeinterface_map_delete(void *);
void *saleaeinterface_id_map_create();
void saleaeinterface_id_map_delete(void *);

void saleaeinterface_begin_connect(saleaeinterface_t *obj);
void saleaeinterface_internal_on_connect(saleaeinterface_t *obj, unsigned int id);
void saleaeinterface_internal_on_disconnect(saleaeinterface_t *obj, unsigned int id);
void saleaeinterface_internal_on_error(saleaeinterface_t *obj, unsigned int id);
void saleaeinterface_internal_on_readdata(saleaeinterface_t *obj, unsigned int id,
                    unsigned char *data, unsigned int len);
void saleaeinterface_internal_on_writedata(saleaeinterface_t *obj, unsigned int id,
                    unsigned char *data, unsigned int len);

unsigned int saleaeinterface_islogic16(saleaeinterface_t *obj, unsigned int id);
unsigned int saleaeinterface_islogic(saleaeinterface_t *obj, unsigned int id);
unsigned int saleaeinterface_isstreaming(saleaeinterface_t *obj, unsigned int id);
unsigned int saleaeinterface_isusb2(saleaeinterface_t *obj, unsigned int id);
unsigned int saleaeinterface_getchannelcount(saleaeinterface_t *obj, unsigned int id);
unsigned int saleaeinterface_getsamplerate(saleaeinterface_t *obj, unsigned int id);
void saleaeinterface_setsamplerate(saleaeinterface_t *obj, unsigned int id, unsigned int rate);
/* the user has to alloc the ptr variable and give it to the function */
int saleaeinterface_getsupportedsamplerates(saleaeinterface_t *obj, unsigned int id,
                            unsigned int *ptr, unsigned int len);

size_t saleaeinterface_get_sdk_id(saleaeinterface_t *obj, unsigned int id,
            char *buf, size_t buflen);

#ifdef __cplusplus
} /* extern C end */
#endif /* __cplusplus */

#endif /* __SALEAE_INTERFACE_XS_H__ */
