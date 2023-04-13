// ==UserScript==
// @name 抖音网页版优化
// @description 抖音网页版优化，网页全屏，自动按浏览器窗口调整大小
// @author       evan
// @namespace    https://ef6.github.io
// @license      GPL3.0
// @date         2022.02.21
// @modified     2022.03.03
// @version 0.1.1
// @updateURL https://cdn.jsdelivr.net/gh/ef6/myscript@main/yh/douyin.user.js
// @include https://www.douyin.com/recommend
// @include https://www.douyin.com/
// @include https://www.douyin.com/follow
// @run-at document-end
// @grant GM_addStyle
// ==/UserScript==
(function() {

let css = `
 body, .oJArD0aS{
  min-width: 360px!important;
 }
.mMOxHVzv, .qqDY_iJX{
  width: ${document.documentElement.clientWidth}px!important;
  padding: 4px!important;
 }
.dUiu6B8O, .MiecXVmm, .s2O1MLsL{
  display: none!important;
 }
.swiper-container, .y4Jb5f1C{
  padding: 0!important;
 }
`;
if (typeof GM_addStyle !== "undefined") {
  GM_addStyle(css);
} else {
  let styleNode = document.createElement("style");
  styleNode.appendChild(document.createTextNode(css));
  (document.querySelector("head") || document.documentElement).appendChild(styleNode);
}
})();
