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
} saleaeinterface_t;

typedef unsigned long long int ID64; /* same as U64 in the API */

/* interface for XS to call */
void *saleaeinterface_map_create();
void saleaeinterface_map_delete(void *);

void saleaeinterface_begin_connect(saleaeinterface_t *obj);
void saleaeinterface_internal_on_connect(saleaeinterface_t *obj, ID64 id);
void saleaeinterface_internal_on_disconnect(saleaeinterface_t *obj, ID64 id);
void saleaeinterface_internal_on_error(saleaeinterface_t *obj, ID64 id);
void saleaeinterface_internal_on_readdata(saleaeinterface_t *obj, ID64 id,
                    unsigned char *data, unsigned int len);
void saleaeinterface_internal_on_writedata(saleaeinterface_t *obj, ID64 id,
                    unsigned char *data, unsigned int len);

unsigned int saleaeinterface_islogic16(saleaeinterface_t *obj, ID64 id);
unsigned int saleaeinterface_islogic(saleaeinterface_t *obj, ID64 id);
unsigned int saleaeinterface_isstreaming(saleaeinterface_t *obj, ID64 id);
unsigned int saleaeinterface_isusb2(saleaeinterface_t *obj, ID64 id);
unsigned int saleaeinterface_getchannelcount(saleaeinterface_t *obj, ID64 id);
unsigned int saleaeinterface_getsamplerate(saleaeinterface_t *obj, ID64 id);
void saleaeinterface_setsamplerate(saleaeinterface_t *obj, ID64 id, unsigned int rate);
/* the user has to alloc the ptr variable and give it to the function */
int saleaeinterface_getsupportedsamplerates(saleaeinterface_t *obj, ID64 id,
                            unsigned int *ptr, unsigned int len);

#ifdef __cplusplus
} /* extern C end */
#endif /* __cplusplus */

#endif /* __SALEAE_INTERFACE_XS_H__ */
