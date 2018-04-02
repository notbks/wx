<%@ Page Language="C#" AutoEventWireup="true" CodeFile="header.aspx.cs" Inherits="Header" %>

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8" />
    <title></title>    
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="format-detection" content="telephone=no" />
<link href="/css/header.css" rel="stylesheet"/>
</head>
<body style="height:40px; margin-top:0px;">
    <table id="table">
        <tr>
            <th style="width:50px;">公众号</th>
            <%
                UserInfo userInfo = new UserInfo();
                if (Session["info"] != null && Session["info"].ToString() != "")
                {
                    String info = Session["info"].ToString();
                    userInfo = JsonHelper.ParseFromJson<UserInfo>(info);
                    String nickname = userInfo.nickname;
                    String headimgurl = userInfo.headimgurl;
            %> 
            <th id="nickname"><%=nickname %></th>
            <th id="headimg"><img src="<%=headimgurl %>"/></th>
            <%
                }
                else
                {
                    %>
                        <th id="nickname">游客</th>
                        <th id="headimg"><img src="/img/visitorheadimg.jpg"/></th>
                    <%
                }
            %>
        </tr>
    </table>
</body>
</html>
