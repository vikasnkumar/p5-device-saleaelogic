#ifdef WIN32
    #include <windows.h>
    #ifndef __func__
        #define __func__ __FUNCTION__
    #endif
    #ifndef _CRT_SECURE_NO_WARNINGS
        #define _CRT_SECURE_NO_WARNINGS
    #endif
	#ifndef WIN32_LEAN_AND_MEAN
		#define WIN32_LEAN_AND_MEAN
	#endif
#else
    #include <unistd.h>
#endif
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <typeinfo>

#include "SaleaeDeviceApi.h"
#include "saleaeinterface.h"

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#define IAMHERE1 fprintf(stderr, "[%s:%d] Entering\n", __func__, __LINE__)
#define IAMHERE2 fprintf(stderr, "[%s:%d] Exiting\n", __func__, __LINE__)

static void cb_onreaddata(U64 id, U8 *data, U32 len, void *udata)
{
    saleaeinterface_t *obj = (saleaeinterface_t *)udata;
    saleaeinterface_internal_on_readdata(obj, data, len);
    if (data)
        DevicesManagerInterface::DeleteU8ArrayPtr(data);
}
static void cb_onwritedata(U64 id, U8 *data, U32 len, void *udata)
{
    saleaeinterface_t *obj = (saleaeinterface_t *)udata;
    /* FIXME: maybe wrong implementation */
    saleaeinterface_internal_on_writedata(obj, data, len);
}
static void cb_onerror(U64 id, void *udata)
{
    saleaeinterface_t *obj = (saleaeinterface_t *)udata;
    saleaeinterface_internal_on_error(obj);
}
static void cb_onconnect(U64 id, GenericInterface *iface, void *udata)
{
    saleaeinterface_t *obj = (saleaeinterface_t *)udata;
    IAMHERE1;
    if (obj) {
        /* setup the interface and device id */
        obj->device_id = id;
        obj->interface = (void *)iface;
        std::string iface_name = typeid(*iface).name();
        fprintf(stderr, "[%s:%d] Interface name: %s\n",
                __func__, __LINE__, iface_name.c_str());
        if (iface_name.find("Logic16Interface") != std::string::npos) {
            obj->itype = SALEAEINTERFACE_LOGIC16;
            Logic16Interface *l16 = dynamic_cast<Logic16Interface *>(iface);
            l16->RegisterOnReadData(cb_onreaddata, udata);
            l16->RegisterOnWriteData(cb_onwritedata, udata);
            l16->RegisterOnError(cb_onerror, udata);
        } else if (iface_name.find("LogicInterface") != std::string::npos) {
            obj->itype = SALEAEINTERFACE_LOGIC;
            LogicInterface *l8 = dynamic_cast<LogicInterface *>(iface);
            l8->RegisterOnReadData(cb_onreaddata, udata);
            l8->RegisterOnWriteData(cb_onwritedata, udata);
            l8->RegisterOnError(cb_onerror, udata);
        } else {
            obj->itype = SALEAEINTERFACE_UNKNOWN;
            fprintf(stderr, "[%s:%d] This is an unsupported device\n",
                    __func__, __LINE__);
        }
        saleaeinterface_internal_on_connect(obj);
    }
    IAMHERE2;
}
static void cb_ondisconnect(U64 id, void *udata)
{
    saleaeinterface_t *obj = (saleaeinterface_t *)udata;
    IAMHERE1;
    saleaeinterface_internal_on_disconnect(obj);
}

void saleaeinterface_begin_connect(saleaeinterface_t *obj)
{
    IAMHERE1;
    if (obj && !obj->begun) {
        obj->begun = 1;
        DevicesManagerInterface::RegisterOnConnect(cb_onconnect, (void *)obj);
        DevicesManagerInterface::RegisterOnDisconnect(cb_ondisconnect, (void *)obj);
        DevicesManagerInterface::BeginConnect();
    }
    IAMHERE2;
}

unsigned int saleaeinterface_isusb2(saleaeinterface_t *obj)
{
    if (obj) {
        GenericInterface *gi = (GenericInterface *)obj->interface;
        LogicAnalyzerInterface *lai = dynamic_cast<LogicAnalyzerInterface *>(gi);
        return lai->IsUsb2pt0() ? 1 : 0;
    }
    return 0;
}

unsigned int saleaeinterface_isstreaming(saleaeinterface_t *obj)
{
    if (obj) {
        GenericInterface *gi = (GenericInterface *)obj->interface;
        LogicAnalyzerInterface *lai = dynamic_cast<LogicAnalyzerInterface *>(gi);
        return lai->IsStreaming() ? 1 : 0;
    }
    return 0;
}

unsigned int saleaeinterface_getchannelcount(saleaeinterface_t *obj)
{
    if (obj) {
        GenericInterface *gi = (GenericInterface *)obj->interface;
        LogicAnalyzerInterface *lai = dynamic_cast<LogicAnalyzerInterface *>(gi);
        return lai->GetChannelCount();
    }
    return 0;
}

unsigned int saleaeinterface_getsamplerate(saleaeinterface_t *obj)
{
    if (obj) {
        GenericInterface *gi = (GenericInterface *)obj->interface;
        LogicAnalyzerInterface *lai = dynamic_cast<LogicAnalyzerInterface *>(gi);
        return lai->GetSampleRateHz();
    }
    return 0;
}

void saleaeinterface_setsamplerate(saleaeinterface_t *obj, unsigned int rate)
{
    if (obj) {
        GenericInterface *gi = (GenericInterface *)obj->interface;
        LogicAnalyzerInterface *lai = dynamic_cast<LogicAnalyzerInterface *>(gi);
        return lai->SetSampleRateHz(rate);
    }

}

#ifdef __cplusplus
} /* extern C end */
#endif /* __cplusplus */
