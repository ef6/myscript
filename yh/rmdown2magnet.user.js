// ==UserScript==
// @name         rmdown2magnet
// @description  草榴rmdown转换磁力链
// @author       evan
// @namespace    https://ef6.github.io
// @license      GPL3.0
// @date         2022.01.18
// @modified     2024.10.30
// @version      1.0.8
// @updateURL    https://cdn.jsdelivr.net/gh/ef6/myscript@main/yh/rmdown2magnet.user.js
// @icon         https://rmdown.com/favicon.ico
// @include      http*://*/htm_data/*.html
// @include      http*://*/htm_mob/*.html
// @grant        none
// @run-at       document-end
// ==/UserScript==

(function() {
    'use strict';
    let title = document.querySelector('#main>.f18').innerText.slice(0,30);
    let node = document.querySelectorAll(".tpc_cont a[href*=rmdown][href*=hash]");
    for(let n of node){
        let magnet = 'magnet:?xt=urn:btih:' + n.href.split('=')[1].slice(3);
        console.log(title,magnet);
        n.innerText=magnet;
        n.href=magnet + '&dn=' + title;
        n.className="h f18";
    }
})();
