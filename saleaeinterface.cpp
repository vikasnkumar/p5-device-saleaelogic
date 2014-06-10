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
    #include <sys/select.h>
    #include <unistd.h>
#endif
#include <stdio.h>
#include <stdlib.h>

#include "SaleaeDeviceApi.h"
#include "saleaeinterface.h"

#if 0
#include <iostream>
#include <typeinfo>
#define LOG std::cerr << "[" << __func__ << ":" << __LINE__ << "]"

typedef enum {
    UNKNOWN,
    LOGIC,
    LOGIC16
} SaleaeLogicInterfaceType;

struct SaleaeLogicUser {
    bool connected;
    bool error;
    SaleaeLogicInterfaceType type; 
    LogicAnalyzerInterface *iface;
    SaleaeLogicUser() {
        connected = false;
        error = false;
        type = UNKNOWN;
        iface = NULL;
    }
};

static void cb_onconnect(U64 id, GenericInterface *iface, void *udata);
static void cb_ondisconnect(U64 id, void *udata);
static void cb_onreaddata(U64 id, U8 *data, U32 len, void *udata);
static void cb_onwritedata(U64 id, U8 *data, U32 len, void *udata);
static void cb_onerror(U64 id, void *udata);

void cb_onconnect(U64 id, GenericInterface *iface, void *udata)
{
    LOG << "Id: " << std::hex << id << std::dec << std::endl;
    struct SaleaeLogicUser *lu = (struct SaleaeLogicUser *)udata;
    if (iface && lu) {
        lu->connected = true;
        lu->error = false;
        std::string iface_name = typeid(*iface).name();
        LOG << "Type: " << iface_name << std::endl;
        if (iface_name.find("Logic16Interface") != std::string::npos) {
            lu->type = LOGIC16;
            LOG << "this is a logic 16 device\n";
            Logic16Interface *l16 = dynamic_cast<Logic16Interface *>(iface);
            l16->RegisterOnReadData(cb_onreaddata, udata);
            l16->RegisterOnWriteData(cb_onwritedata, udata);
            l16->RegisterOnError(cb_onerror, udata);
            lu->iface = dynamic_cast<LogicAnalyzerInterface *>(iface);
            LOG << "Use 5.0V ? " << (l16->GetUse5Volts() ? "Y" : "N")
                << std::endl;
        } else if (iface_name.find("LogicInterface") != std::string::npos) {
            lu->type = LOGIC;
            LOG << "this is a logic device\n";
            LogicInterface *l8 = dynamic_cast<LogicInterface *>(iface);
            l8->RegisterOnReadData(cb_onreaddata, udata);
            l8->RegisterOnWriteData(cb_onwritedata, udata);
            l8->RegisterOnError(cb_onerror, udata);
            lu->iface = dynamic_cast<LogicAnalyzerInterface *>(iface);
        } else {
            lu->type = UNKNOWN;
            LOG << "this is an unknown or unsupported device\n";
            lu->iface = NULL;
            return;
        }
        if (lu->iface) {
            LOG << "USB 2.0: " << (lu->iface->IsUsb2pt0() ? "true" : "false")
                << std::endl;
            LOG << "Channel count: " << lu->iface->GetChannelCount()
                << std::endl;
            LOG << "Sample Rate: " << lu->iface->GetSampleRateHz() << " Hz\n";
            const U32 count= 16;
            U32 *buf = new U32[count];
            if (buf) {
                S32 rc = lu->iface->GetSupportedSampleRates(buf, count);
                LOG << "Available Sample Rates in Hz: [" << rc << "]\t";
                for (U32 i = 0; i < rc && rc > 0; ++i) {
                    std::cerr << buf[i] << ",";
                }
                std::cerr << std::endl;
                delete [] buf;
            }
        }
    } 
}

void cb_ondisconnect(U64 id, void *udata)
{
    struct SaleaeLogicUser *lu = (struct SaleaeLogicUser *)udata;
    LOG << "Id: " << std::hex << id << std::dec << std::endl;
    if (lu) {
        lu->connected = false;
    }
}

void cb_onreaddata(U64 id, U8 *data, U32 len, void *udata)
{
    struct SaleaeLogicUser *lu = (struct SaleaeLogicUser *)udata;
    LOG << "Id: " << std::hex << id << std::dec << std::endl;

}

// seems to work only for Logic and not Logic16
void cb_onwritedata(U64 id, U8 *data, U32 len, void *udata)
{
    struct SaleaeLogicUser *lu = (struct SaleaeLogicUser *)udata;
    LOG << "Id: " << std::hex << id << std::dec << std::endl;
}

void cb_onerror(U64 id, void *udata)
{
    LOG << "Id: " << std::hex << id << std::dec << std::endl;
    struct SaleaeLogicUser *lu = (struct SaleaeLogicUser *)udata;
    if (lu) {
        lu->error = true;
        LOG << "Whoa! Error!!\n";
    }
}

#endif

#define IAMHERE1 fprintf(stderr, "[%s:%d] Entering\n", __func__, __LINE__)
#define IAMHERE2 fprintf(stderr, "[%s:%d] Exiting\n", __func__, __LINE__)

saleaeinterface_t *saleaeinterface_new()
{
    saleaeinterface_t *obj = NULL;
    IAMHERE1;
    obj = (saleaeinterface_t *)malloc(sizeof(*obj));
    if (obj) {
        obj->itype = saleaeinterface_t::UNKNOWN;
        obj->ptr = NULL;
    } else {
        fprintf(stderr, "[%s:%d]Unable to allocate object\n",
                __func__, __LINE__);
    }
    IAMHERE2;
    return obj;
}

void saleaeinterface_DESTROY(saleaeinterface_t *obj)
{
    IAMHERE1;
    if (obj) {
        free(obj);
        obj = NULL;
    }
    IAMHERE2;
}

void saleaeinterface_begin_connect()
{
    IAMHERE1;
    DevicesManagerInterface::BeginConnect();
    IAMHERE2;
}

void saleaeinterface_register_on_connect(saleaeinterface_t *obj)
{
}

void saleaeinterface_register_on_disconnect(saleaeinterface_t *obj)
{
}

void saleaeinterface_register_on_readdata(saleaeinterface_t *obj)
{
}

void saleaeinterface_register_on_writedata(saleaeinterface_t *obj)
{
}

void saleaeinterface_register_on_error(saleaeinterface_t *obj)
{
}

#if 0
int main (int argc, char **argv)
{
    struct SaleaeLogicUser lu;
    struct timeval tv;
    DevicesManagerInterface::RegisterOnConnect(cb_onconnect, &lu);
    DevicesManagerInterface::RegisterOnDisconnect(cb_ondisconnect, &lu);
    DevicesManagerInterface::BeginConnect();
    LOG << "Please wait while we connect to the device...\n";
    tv.tv_sec = 2;
    tv.tv_usec = 0;
    while (select(0, NULL, NULL, NULL, &tv) != -1) {
        if (lu.error)
            break;
        tv.tv_sec = 2;
        tv.tv_usec = 0;
    }
    return 0;
}
#endif // 0
