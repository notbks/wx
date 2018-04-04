<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="Index" %>

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />   
<meta http-equiv="X-UA-Compatible" content="IE=edge" />  
    <title></title>    
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="format-detection" content="telephone=no" />

<link rel="stylesheet" href="css/common.css"/>
<script src="js/jweixin-1.2.0.js"></script>
<script src="js/vue.min.js"></script>

</head>
<body>
    <!-- header -->
    <iframe src="include/header.aspx" frameborder="0" width="100%"></iframe>
    <!-- header -->

    <table>
        <tr>
            <th></th>
        </tr>
    </table>
    ~~~<br />

    <div id="share">
        <button v-on:click="share">share</button>
        <button v-on:click="aaa">aaae</button>
    </div>
    <script>
        new Vue({
            el:'#share',
            methods: {
                share:function(event){
                    wx.onMenuShareTimeline({
                        title: '测试', // 分享标题
                        link: 'http://niq8m5.natappfree.cc/index.aspx', // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
                        imgUrl: 'http://niq8m5.natappfree.cc/img/common.jpg', // 分享图标
                        success: function () {
                            //alert("success");
                        },
                        cancel: function () {
                            //alert("fail");
                        }
                    });
                    if (event) {
                    	alert(event.target.tagName)
                    }
                },
                aaa: function () {
                    alert("aaa");
                }
            }
        })
    </script>
    ~~~<br />
    ~~~<br />
    <img width="300px" src="img/visitorheadimg.jpg"/>
    v
    v
    v
    v
    v
    v
    ~~~<br />
    ~~~<br />
    ~~~<br />
    ~~~<br />
    ~~~<br />
    v
    v
    ~~~<br />
    ~~~<br />
    v
    ~~~<br />
    v
    ~~~<br />
    ~~~<br />
  ~~~<br />
    v
    v
    ~~~<br />
    ~~~<br />
    v
    ~~~<br />
    v
    ~~~<br />
    ~~~<br />

    ~~~<br />
   ~~~<br />

    <span style="word-wrap: break-word !important; box-sizing: border-box !important; ">~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~<br />   ~~~<br /></span>

    ~~~<br />   ~~~<br />

    ~~~<br />	
    <style type="text/css">
    	#footer img{
		    top: 0;
		    width: 50px;
		    height: 50px;
		}
		#footer table{
		    width: 100%;
		    height: 55px;
		}
		#footer th{
		    width: 25%;
		}
		#footer{
		    left: 0;  
		    position: fixed;  
		    bottom: 0;
		    width: 100%;
		    height: 50px;
		    z-index: 100;
		    background-color: aliceblue;
		
		    padding-top: 0px;
		}
    </style>
    <div id="footer">
        <table>
            <tr>
                <th><a href="#"><img src="/img/bottom/1.png"/></a></th>
                <th><a href="/order/order.aspx"><img src="/img/bottom/2.jpg"/></a></th>
                <th><a href="#"><img src="/img/bottom/3.jpg"/></a></th>
                <th><a href="#"><img src="/img/bottom/4.jpg"/></a></th>
            </tr>
        </table>
    </div>

    <!--  -->
<!--    <iframe id="footer" src="include/footer.aspx" frameborder="0" scrolling="no"></iframe>-->
    <!--  -->
</body>
</html>
