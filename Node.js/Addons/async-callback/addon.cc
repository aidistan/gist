#include <nan.h>
#include <iostream>
#include <thread>

namespace addon {

class Worker : public Nan::AsyncWorker {
  public:
    Worker(Nan::Callback *callback) : Nan::AsyncWorker(callback), integer(5) {}
    ~Worker() {}

    void Execute() {
      std::cout<<"Work thread: "<<std::this_thread::get_id()<<std::endl;
    }

    void HandleOKCallback() {
      Nan::HandleScope scope;

      const unsigned argc = 1;
      v8::Local<v8::Value> argv[argc] = {
        Nan::New("Hello, world!").ToLocalChecked()
      };
      callback->Call(argc, argv);

      std::cout<<"Main thread: "<<std::this_thread::get_id()<<std::endl;
    }

  private:
    int integer;
};

NAN_METHOD(RunCallback) {
  Nan::Callback *callback = new Nan::Callback(info[0].As<v8::Function>());
  Nan::AsyncQueueWorker(new Worker(callback));
}

void Init(v8::Local<v8::Object> exports, v8::Local<v8::Object> module) {
  Nan::SetMethod(module, "exports", RunCallback);
}

NODE_MODULE(addon, Init)

}
