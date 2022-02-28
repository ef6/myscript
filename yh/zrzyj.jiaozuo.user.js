// ==UserScript==
// @name         焦作市自然资源交易系统显示单价
// @description  焦作市自然资源网上交易系统显示单价
// @author       evan
// @namespace    https://ef6.github.io
// @license      GPL3.0
// @date         2022.01.18
// @modified     2022.02.10
// @version      1.1.0
// @icon         http://zrzyj.jiaozuo.gov.cn/favicon.ico
// @match        http*://jy.zrzyj.jiaozuo.gov.cn*/trade-engine/trade/resources*
// @match        http*://jy.zrzyj.jiaozuo.gov.cn*/trade-engine/trade/collectiveresources*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    function displayMu(){
        Array.from(document.querySelectorAll(".resource-list")).forEach((Elem) => {
            if(! Elem.querySelector(".hasMu")){
                let mj=Elem.querySelector("span[ng-bind*=CRMJ]").innerText;
                let jg=Elem.querySelector("span[ng-bind*=ZGBJ]").innerText.slice(1);
                if(mj>0 && jg>0){
                    let dj=(jg*10000)/mj;
                    let djm=dj/15;
                    let el = document.createElement("a");
                    el.className="hasMu color-red font-bold";
                    el.innerText=String.format("{0}元/㎡ {1}万元/亩",dj.toFixed(0),djm.toFixed(0));
                    Elem.querySelector(".resource-list-header").append(el)
                }
            }
        });
    }
    new MutationObserver((mutationRecords, observer) => {
        console.log("document is change");
        setTimeout(displayMu,1000);
        //observer.disconnect();
    }).observe(document.querySelector(".land-list-container"), {
        childList: true,
        //subtree: true
    });
})();
