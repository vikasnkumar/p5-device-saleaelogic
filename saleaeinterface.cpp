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
#include <map>

#include "SaleaeDeviceApi.h"
#include "saleaeinterface.h"

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#define IAMHERE1 fprintf(stderr, "[%s:%d] Entering\n", __func__, __LINE__)
#define IAMHERE2 fprintf(stderr, "[%s:%d] Exiting\n", __func__, __LINE__)
typedef std::map <U64, GenericInterface *> SIMap;
typedef std::pair <U64, GenericInterface *> SIPair;

/* interface for XS to call */
void *saleaeinterface_map_create()
{
    SIMap *p = new SIMap;
    return (void *)p;
}

void saleaeinterface_map_delete(void *p)
{
    if (p) {
        SIMap *m = (SIMap *)p;
        delete m;
    }
}

static void saleaeinterface_map_insert(void *p, U64 id, GenericInterface *iface)
{
    if (p) {
        SIMap *m = (SIMap *)p;
        SIMap::iterator mi = m->find(id);
        /* force insertion */
        if (mi != m->end()) {
            m->erase(mi);
        }
        m->insert(SIPair(id, iface));
    }
}

static void saleaeinterface_map_erase(void *p, U64 id)
{
    if (p) {
        SIMap *m = (SIMap *)p;
        SIMap::iterator mi = m->find(id);
        if (mi != m->end()) {
            m->erase(mi);
        }
    }
}

static size_t saleaeinterface_map_size(void *p)
{
    if (p) {
        SIMap *m = (SIMap *)p;
        return m->size();
    }
    return 0;
}

static GenericInterface *saleaeinterface_map_get(void *p, U64 id)
{
    if (p) {
        SIMap *m = (SIMap *)p;
        SIMap::iterator mi = m->find(id);
        if (mi != m->end())
            return mi->second;
    }
    return NULL;
}

static int saleaeinterface_get_type(GenericInterface *iface)
{
    if (!iface)
        return SALEAEINTERFACE_UNKNOWN;
    std::string iface_name = typeid(*iface).name();
    fprintf(stderr, "[%s:%d] Interface name: %s\n",
            __func__, __LINE__, iface_name.c_str());
    if (iface_name.find("Logic16Interface") != std::string::npos) {
        return SALEAEINTERFACE_LOGIC16;
    } else if (iface_name.find("LogicInterface") != std::string::npos) {
        return SALEAEINTERFACE_LOGIC;
    }
    return SALEAEINTERFACE_UNKNOWN;
}

static void cb_onreaddata(U64 id, U8 *data, U32 len, void *udata)
{
    saleaeinterface_t *obj = (saleaeinterface_t *)udata;
    saleaeinterface_internal_on_readdata(obj, id, data, len);
    if (data)
        DevicesManagerInterface::DeleteU8ArrayPtr(data);
}
static void cb_onwritedata(U64 id, U8 *data, U32 len, void *udata)
{
    saleaeinterface_t *obj = (saleaeinterface_t *)udata;
    /* FIXME: maybe wrong implementation */
    saleaeinterface_internal_on_writedata(obj, id, data, len);
}
static void cb_onerror(U64 id, void *udata)
{
    saleaeinterface_t *obj = (saleaeinterface_t *)udata;
    saleaeinterface_internal_on_error(obj, id);
}
static void cb_onconnect(U64 id, GenericInterface *iface, void *udata)
{
    saleaeinterface_t *obj = (saleaeinterface_t *)udata;
    IAMHERE1;
    if (obj) {
        int type = saleaeinterface_get_type(iface);
        /* setup the interface and device id */
        saleaeinterface_map_insert(obj->interface_map, id, iface);
        obj->interface_count = saleaeinterface_map_size(obj->interface_map);
        if (type == SALEAEINTERFACE_LOGIC16) {
            Logic16Interface *l16 = dynamic_cast<Logic16Interface *>(iface);
            l16->RegisterOnReadData(cb_onreaddata, udata);
            l16->RegisterOnWriteData(cb_onwritedata, udata);
            l16->RegisterOnError(cb_onerror, udata);
        } else if (type == SALEAEINTERFACE_LOGIC) {
            LogicInterface *l8 = dynamic_cast<LogicInterface *>(iface);
            l8->RegisterOnReadData(cb_onreaddata, udata);
            l8->RegisterOnWriteData(cb_onwritedata, udata);
            l8->RegisterOnError(cb_onerror, udata);
        } else {
            fprintf(stderr, "[%s:%d] This is an unsupported device\n",
                    __func__, __LINE__);
            return;
        }
        saleaeinterface_internal_on_connect(obj, id);
    }
    IAMHERE2;
}
static void cb_ondisconnect(U64 id, void *udata)
{
    saleaeinterface_t *obj = (saleaeinterface_t *)udata;
    IAMHERE1;
    saleaeinterface_map_erase(obj->interface_map, id);
    obj->interface_count = saleaeinterface_map_size(obj->interface_map);
    saleaeinterface_internal_on_disconnect(obj, id);
    IAMHERE2;
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

unsigned int saleaeinterface_isusb2(saleaeinterface_t *obj, U64 id)
{
    if (obj) {
        GenericInterface *gi = saleaeinterface_map_get(obj->interface_map, id);
        if (gi) {
            LogicAnalyzerInterface *lai = dynamic_cast<LogicAnalyzerInterface *>(gi);
            return lai->IsUsb2pt0() ? 1 : 0;
        }
    }
    return 0;
}

unsigned int saleaeinterface_isstreaming(saleaeinterface_t *obj, U64 id)
{
    if (obj) {
        GenericInterface *gi = saleaeinterface_map_get(obj->interface_map, id);
        if (gi) {
            LogicAnalyzerInterface *lai = dynamic_cast<LogicAnalyzerInterface *>(gi);
            return lai->IsStreaming() ? 1 : 0;
        }
    }
    return 0;
}

unsigned int saleaeinterface_getchannelcount(saleaeinterface_t *obj, U64 id)
{
    if (obj) {
        GenericInterface *gi = saleaeinterface_map_get(obj->interface_map, id);
        if (gi) {
            LogicAnalyzerInterface *lai = dynamic_cast<LogicAnalyzerInterface *>(gi);
            return lai->GetChannelCount();
        }
    }
    return 0;
}

unsigned int saleaeinterface_getsamplerate(saleaeinterface_t *obj, U64 id)
{
    if (obj) {
        GenericInterface *gi = saleaeinterface_map_get(obj->interface_map, id);
        if (gi) {
            LogicAnalyzerInterface *lai = dynamic_cast<LogicAnalyzerInterface *>(gi);
            return lai->GetSampleRateHz();
        }
    }
    return 0;
}

void saleaeinterface_setsamplerate(saleaeinterface_t *obj, U64 id, unsigned int rate)
{
    if (obj) {
        GenericInterface *gi = saleaeinterface_map_get(obj->interface_map, id);
        if (gi) {
            LogicAnalyzerInterface *lai = dynamic_cast<LogicAnalyzerInterface *>(gi);
            lai->SetSampleRateHz(rate);
        }
    }
}

int saleaeinterface_getsupportedsamplerates(saleaeinterface_t *obj, U64 id,
                            unsigned int *ptr, unsigned int len)
{
    if (obj && ptr) {
        GenericInterface *gi = saleaeinterface_map_get(obj->interface_map, id);
        if (gi) {
            LogicAnalyzerInterface *lai = dynamic_cast<LogicAnalyzerInterface *>(gi);
            S32 rc = lai->GetSupportedSampleRates(ptr, (U32)len);
            return (int)rc;
        }
    }
    return 0;
}

#ifdef __cplusplus
} /* extern C end */
#endif /* __cplusplus */
