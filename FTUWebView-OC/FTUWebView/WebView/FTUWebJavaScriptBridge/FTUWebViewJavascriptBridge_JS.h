#import <Foundation/Foundation.h>

NSString *FTUWebViewJavascriptBridge_JS(void);

/* Web环境初始化
function setupWebViewJavascriptBridge(callback) {
  //第一次调用这个方法的时候，为false
 if (window.WebViewJavascriptBridge) {
     var result = callback(WebViewJavascriptBridge);
     return result;
 }
 //第一次调用的时候，也是false
 if (window.WVJBCallbacks) {
     var result = window.WVJBCallbacks.push(callback);
     return result;
 }
 //把callback对象赋值给对象。
 window.WVJBCallbacks = [callback];
 //为了执行加载WebViewJavascriptBridge_JS.js中代码，创建一个iframe，改变iframed的src属性，从而触发webView代理，捕获状态
 var WVJBIframe = document.createElement('iframe');
 WVJBIframe.style.display = 'none';
 WVJBIframe.src = 'https://__bridge_loaded__';
 document.documentElement.appendChild(WVJBIframe);
 setTimeout(function() {
     document.documentElement.removeChild(WVJBIframe)
 }, 0);
}

//setupWebViewJavascriptBridge执行的时候传入的参数，这是一个方法。
function callback(bridge) {
 var uniqueId = 1
 //把WEB中要注册的方法注册到bridge里面
 bridge.registerHandler('JS提供给OC的方法', function(data, responseCallback) {
     log('OC调用JS方法成功', data)
     var responseData = { 'JS提供给OC调用的回调':'回调值!' }
     log('OC调用JS的返回值', responseData)
     responseCallback(responseData)
 })
};
//驱动所有hander的初始化
setupWebViewJavascriptBridge(callback);
 
 */
