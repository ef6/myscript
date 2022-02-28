// ==UserScript==
// @name 抖音网页版优化
// @description 抖音网页版优化，网页全屏，自动按浏览器窗口调整大小，自动释放内存
// @author       evan
// @namespace    https://ef6.github.io
// @license      GPL3.0
// @date         2022.02.21
// @modified     2022.02.22
// @version 0.0.2
// @include https://www.douyin.com/recommend
// @include https://www.douyin.com/
// @include https://www.douyin.com/follow
// @run-at document-end
// ==/UserScript==
setTimeout(function() {
    'use strict';
    var cliWid=document.documentElement.clientWidth+"px";
    function elementReady(selector) {
        return new Promise((resolve, reject) => {
            let el = document.querySelector(selector);
            if (el) {
              resolve(el); 
              return
            }
            new MutationObserver((mutationRecords, observer) => {
              Array.from(document.querySelectorAll(selector)).forEach((element) => {
                resolve(element);
                //Once we have resolved we don't need the observer anymore.
                observer.disconnect();
              });
            }).observe(document.documentElement, {
            childList: true,
            subtree: true
          });
        });
    }
    //elementReady("body").then((el)=>{el.style.minWidth=cliWid;})
    
    function waitForElem(selector, callback){
        let elem=document.querySelector(selector)
        if(elem) callback(elem);
        new MutationObserver((mutationRecords, observer) => {
            let elem=document.querySelector(selector)
            if(elem){
                console.log("[GET]",selector)
                observer.disconnect();
                callback(elem);
            }
        }).observe(document.documentElement, {
            childList: true,
            subtree: true
        });
    }
    waitForElem("body",(el)=>{el.style.minWidth=cliWid;});
    waitForElem(".dUiu6B8O",(el)=>{el.hidden=true;});//side
    waitForElem(".oJArD0aS",(el)=>{el.style.minWidth=cliWid;
el.querySelector('div>div').style.padding='0';});//header
    waitForElem("#root .MiecXVmm",(el)=>{el.remove();});
    waitForElem("#root>div>div:nth-child(3)",(el)=>{el.remove();});
    waitForElem(".swiper-container",(el)=>{el.style.padding='0';});
    waitForElem(".rrKCA47Q",(el)=>{el.style.width=cliWid;});
}, 1000);