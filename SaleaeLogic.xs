#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "saleaeinterface.h"

void saleaeinterface_internal_on_connect(saleaeinterface_t *obj, ID64 id)
{
    dSP;
    PUSHMARK(SP);
    if (obj && obj->parent && obj->on_connect) {
        XPUSHs((SV *)obj->parent);
        XPUSHs(sv_2mortal(newSVuv(id)));
        PUTBACK;
        call_sv((SV *)obj->on_connect, G_DISCARD);
    }
}
void saleaeinterface_internal_on_disconnect(saleaeinterface_t *obj, ID64 id)
{
    dSP;
    PUSHMARK(SP);
    if (obj && obj->parent && obj->on_disconnect) {
        XPUSHs((SV *)obj->parent);
        XPUSHs(sv_2mortal(newSVuv(id)));
        PUTBACK;
        call_sv((SV *)obj->on_disconnect, G_DISCARD);
    }
}
void saleaeinterface_internal_on_error(saleaeinterface_t *obj, ID64 id)
{
    dSP;
    PUSHMARK(SP);
    if (obj && obj->parent && obj->on_error) {
        XPUSHs((SV *)obj->parent);
        XPUSHs(sv_2mortal(newSVuv(id)));
        PUTBACK;
        call_sv((SV *)obj->on_error, G_DISCARD);
    }
}
void saleaeinterface_internal_on_readdata(saleaeinterface_t *obj, ID64 id,
                    unsigned char *data, unsigned int len)
{
    dSP;
    PUSHMARK(SP);
    if (obj && obj->parent && obj->on_readdata) {
        SV *psv = newSV(0);
        SvPVX(psv) = data;
        SvCUR(psv) = len;
        SvLEN(psv) = 0;
        XPUSHs((SV *)obj->parent);
        XPUSHs(sv_2mortal(newSVuv(id)));
        XPUSHs(psv);
        XPUSHs(sv_2mortal(newSVuv(len)));
        PUTBACK;
        call_sv((SV *)obj->on_readdata, G_DISCARD);
    }
}
void saleaeinterface_internal_on_writedata(saleaeinterface_t *obj, ID64 id,
                    unsigned char *data, unsigned int len)
{
    dSP;
    PUSHMARK(SP);
    if (obj && obj->parent && obj->on_writedata) {
        /* FIXME: this is a wrong implementation */
        SV *psv = newSV(0);
        SvPVX(psv) = data;
        SvCUR(psv) = len;
        SvLEN(psv) = 0;
        XPUSHs((SV *)obj->parent);
        XPUSHs(sv_2mortal(newSVuv(id)));
        XPUSHs(psv);
        XPUSHs(sv_2mortal(newSVuv(len)));
        PUTBACK;
        call_sv((SV *)obj->on_writedata, G_DISCARD);
    }
}

MODULE = Device::SaleaeLogic		PACKAGE = Device::SaleaeLogic		

PROTOTYPES: ENABLE

void
saleaeinterface_begin_connect(obj)
    saleaeinterface_t *obj

void
saleaeinterface_register_on_connect(obj, cb)
    saleaeinterface_t *obj
    SV* cb
        CODE:
            /* save a copy of the callback */
            if (obj && !obj->on_connect) {
                obj->on_connect = newSVsv(cb);
            } else {
                SvSetSV((SV *)obj->on_connect, cb);
            }

void
saleaeinterface_register_on_disconnect(obj, cb)
    saleaeinterface_t *obj
    SV* cb
        CODE:
            /* save a copy of the callback */
            if (obj && !obj->on_disconnect) {
                obj->on_disconnect = newSVsv(cb);
            } else {
                SvSetSV((SV *)obj->on_disconnect, cb);
            }

void
saleaeinterface_register_on_readdata(obj, cb)
    saleaeinterface_t *obj
    SV* cb
        CODE:
            /* save a copy of the callback */
            if (obj && !obj->on_readdata) {
                obj->on_readdata = newSVsv(cb);
            } else {
                SvSetSV((SV *)obj->on_readdata, cb);
            }

void
saleaeinterface_register_on_writedata(obj, cb)
    saleaeinterface_t *obj
    SV* cb
        CODE:
            /* save a copy of the callback */
            if (obj && !obj->on_writedata) {
                obj->on_writedata = newSVsv(cb);
            } else {
                SvSetSV((SV *)obj->on_writedata, cb);
            }

void
saleaeinterface_register_on_error(obj, cb)
    saleaeinterface_t *obj
    SV* cb
        CODE:
            /* save a copy of the callback */
            if (obj && !obj->on_error) {
                obj->on_error = newSVsv(cb);
            } else {
                SvSetSV((SV *)obj->on_error, cb);
            }

saleaeinterface_t *
saleaeinterface_new(parent)
    SV *parent
    CODE:
        RETVAL = (saleaeinterface_t *)malloc(sizeof(saleaeinterface_t));
        if (RETVAL) {
            memset(RETVAL, 0, sizeof(saleaeinterface_t));
            RETVAL->begun = 0;
            RETVAL->interface_count = 0;
            RETVAL->interface_map = saleaeinterface_map_create();
            /* make a reference to the parent calling object */
            RETVAL->parent = newSVsv(parent);
        } else {
            Perl_croak(aTHX_ "No memory to allocate saleaeinterface_t object\n");
        }
    OUTPUT:
        RETVAL

void
saleaeinterface_DESTROY(obj)
    saleaeinterface_t *obj
    CODE:
        if (obj) {
            saleaeinterface_map_delete(obj->interface_map);
            free(obj);
            obj = NULL;
        }

unsigned int
saleaeinterface_is_usb2(obj, id)
    saleaeinterface_t *obj
    ID64 id
    CODE:
        RETVAL = saleaeinterface_isusb2(obj, id);
    OUTPUT:
        RETVAL

unsigned int
saleaeinterface_is_streaming(obj, id)
    saleaeinterface_t *obj
    ID64 id
    CODE:
        RETVAL = saleaeinterface_isstreaming(obj, id);
    OUTPUT:
        RETVAL

unsigned int
saleaeinterface_get_channel_count(obj, id)
    saleaeinterface_t *obj
    ID64 id
    CODE:
        RETVAL = saleaeinterface_getchannelcount(obj, id);
    OUTPUT:
        RETVAL

unsigned int
saleaeinterface_get_sample_rate(obj, id)
    saleaeinterface_t *obj
    ID64 id
    CODE:
        RETVAL = saleaeinterface_getsamplerate(obj, id);
    OUTPUT:
        RETVAL

void saleaeinterface_set_sample_rate(obj, id, hz)
    saleaeinterface_t *obj
    ID64 id
    unsigned int hz
    CODE:
        if (hz > 0) {
            saleaeinterface_setsamplerate(obj, id, hz);
        }

SV *
saleaeinterface_get_supported_sample_rates(obj, id)
    saleaeinterface_t *obj
    ID64 id
    PREINIT:
        AV *results;
        unsigned int *buf = NULL;
        unsigned int blen = 32;
        int outlen = 0;
        int i = 0;
    CODE:
        buf = malloc(blen * sizeof(unsigned int));
        if (!buf) {
            Perl_croak(aTHX_ "No memory to allocate 16 array of integers\n");
            XSRETURN_UNDEF;
        } else {
            memset(buf, 0, blen * sizeof(unsigned int));
        }
        results = (AV *)sv_2mortal((SV *)newAV());
        outlen = saleaeinterface_getsupportedsamplerates(obj, id, buf, blen);
        if (outlen > 0) {
            for (i = 0; i < outlen && i < blen; ++i) {
                av_push(results, newSVuv(buf[i]));
            }
        }
        RETVAL = newRV_noinc((SV *)results);
        if (buf) {
            free(buf);
        }
    OUTPUT:
       RETVAL

unsigned int
saleaeinterface_is_logic16(obj, id)
    saleaeinterface_t *obj
    ID64 id
    CODE:
        RETVAL = saleaeinterface_islogic16(obj, id);
    OUTPUT:
        RETVAL

unsigned int
saleaeinterface_is_logic(obj, id)
    saleaeinterface_t *obj
    ID64 id
    CODE:
        RETVAL = saleaeinterface_islogic(obj, id);
    OUTPUT:
        RETVAL
