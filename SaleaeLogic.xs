#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "saleaeinterface.h"

void saleaeinterface_internal_on_connect(saleaeinterface_t *obj)
{
    dSP;
    PUSHMARK(SP);
    if (obj && obj->parent && obj->on_connect) {
        XPUSHs((SV *)obj->parent);
        XPUSHs(sv_2mortal(newSVuv(obj->device_id)));
        PUTBACK;
        call_sv((SV *)obj->on_connect, G_DISCARD);
    }
}
void saleaeinterface_internal_on_disconnect(saleaeinterface_t *obj)
{
    dSP;
    PUSHMARK(SP);
    if (obj && obj->parent && obj->on_disconnect) {
        XPUSHs((SV *)obj->parent);
        XPUSHs(sv_2mortal(newSVuv(obj->device_id)));
        PUTBACK;
        call_sv((SV *)obj->on_disconnect, G_DISCARD);
    }
}
void saleaeinterface_internal_on_error(saleaeinterface_t *obj)
{
    dSP;
    PUSHMARK(SP);
    if (obj && obj->parent && obj->on_error) {
        XPUSHs((SV *)obj->parent);
        XPUSHs(sv_2mortal(newSVuv(obj->device_id)));
        PUTBACK;
        call_sv((SV *)obj->on_error, G_DISCARD);
    }
}
void saleaeinterface_internal_on_readdata(saleaeinterface_t *obj,
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
        XPUSHs(sv_2mortal(newSVuv(obj->device_id)));
        XPUSHs(psv);
        XPUSHs(sv_2mortal(newSVuv(len)));
        PUTBACK;
        call_sv((SV *)obj->on_readdata, G_DISCARD);
    }
}
void saleaeinterface_internal_on_writedata(saleaeinterface_t *obj,
                    unsigned char *data, unsigned int len)
{
    dSP;
    PUSHMARK(SP);
    if (obj && obj->parent && obj->on_writedata) {
        SV *psv = newSV(0);
        SvPVX(psv) = data;
        SvCUR(psv) = len;
        SvLEN(psv) = 0;
        XPUSHs((SV *)obj->parent);
        XPUSHs(sv_2mortal(newSVuv(obj->device_id)));
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
            RETVAL->itype = SALEAEINTERFACE_UNKNOWN;
            RETVAL->begun = 0;
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
            free(obj);
            obj = NULL;
        }
