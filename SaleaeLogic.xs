#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "saleaeinterface.h"

MODULE = Device::SaleaeLogic		PACKAGE = Device::SaleaeLogic		

PROTOTYPES: ENABLE

void
saleaeinterface_begin_connect()

void
saleaeinterface_register_on_connect(obj)
    saleaeinterface_t *obj

void
saleaeinterface_register_on_disconnect(obj)
    saleaeinterface_t *obj

void
saleaeinterface_register_on_readdata(obj)
    saleaeinterface_t *obj

void
saleaeinterface_register_on_writedata(obj)
    saleaeinterface_t *obj

void
saleaeinterface_register_on_error(obj)
    saleaeinterface_t *obj

saleaeinterface_t *
saleaeinterface_new()
    CODE:
    RETVAL = saleaeinterface_new();
    OUTPUT:
    RETVAL

void
saleaeinterface_DESTROY(obj)
    saleaeinterface_t *obj
    CODE:
    saleaeinterface_DESTROY(obj);
