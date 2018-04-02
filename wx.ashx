<%@ WebHandler Language="C#" Class="GenericHandler2" %>

using System;
using System.Web;
using System.Net;
//StreamReader
using System.IO;
//Encoding
using System.Text;
//序列化，json
using System.Runtime.Serialization;
using System.ServiceModel.Web;
using System.Runtime.Serialization.Json;
//xml
using System.Xml;
using System.Xml.Linq;


    public class GenericHandler2 : IHttpHandler
    {
        /// <summary>
        /// Token验证
        /// </summary>
        /// <param name="context"></param>
        public void ProcessRequest(HttpContext context)
        {
            string postString = string.Empty;
            Access_token AT = null;

            if (context.Request.HttpMethod.ToUpper() == "POST")
            {

                //AT = GetAccess_token();

                using (Stream stream = context.Request.InputStream)
                {
                    Byte[] postBytes = new Byte[stream.Length];
                    stream.Read(postBytes, 0, (Int32)stream.Length);
                    postString = Encoding.UTF8.GetString(postBytes);

                    if (!string.IsNullOrEmpty(postString))
                    {
                        /// 处理信息并应答
                        String responseContent = returnMessage(postString);
                        context.Response.ContentEncoding = Encoding.UTF8;
                        context.Response.Write(responseContent);
                        context.Response.End();
                    }
                }
            }
            else
            {
                // 微信接入验证
                token(context);
            }
        }

    
        /// <summary>
        /// 处理消息的方法
        /// </summary>
        /// <param name="postStr"></param>
        /// <returns></returns>
        public static string returnMessage(String postStr)
        {
            XmlDocument xmlDoc = new XmlDocument();
            String responseContent = "";

            try
            {
                //读取请求里的xml
                xmlDoc.Load(new System.IO.MemoryStream(System.Text.Encoding.UTF8.GetBytes(postStr)));
                //获取各个子节点
                XmlNode toUserName = xmlDoc.SelectSingleNode("/xml/ToUserName");
                XmlNode fromUserName = xmlDoc.SelectSingleNode("/xml/FromUserName");
                XmlNode msgType = xmlDoc.SelectSingleNode("/xml/MsgType");
                //XmlNode content = xmlDoc.SelectSingleNode("/xml/Content");

                String say ="哎呀，甭急";
                
                responseContent = string.Format(Message_Text, fromUserName.InnerText, toUserName.InnerText, DateTime.Now.Ticks, say);
                


            }
            catch (Exception ex)
            {
                //读取请求里的xml
                xmlDoc.Load(new System.IO.MemoryStream(System.Text.Encoding.UTF8.GetBytes(postStr)));
                //获取各个子节点
                XmlNode toUserName = xmlDoc.SelectSingleNode("/xml/ToUserName");
                XmlNode fromUserName = xmlDoc.SelectSingleNode("/xml/FromUserName");
                XmlNode msgType = xmlDoc.SelectSingleNode("/xml/MsgType");
                //XmlNode content = xmlDoc.SelectSingleNode("/xml/content");
                responseContent = string.Format(Message_Text, fromUserName.InnerText, toUserName.InnerText, DateTime.Now.Ticks, ex.Message);
            }
            
            
            
            return responseContent;
            
        }
        /// <summary>
        /// 普通文本消息,xml
        /// </summary>
        public static string Message_Text
        {
            get
            {
                //注意<MsgType>是写死的
                return @"<xml>
                            <ToUserName><![CDATA[{0}]]></ToUserName>
                            <FromUserName><![CDATA[{1}]]></FromUserName>
                            <CreateTime>{2}</CreateTime>
                            <MsgType><![CDATA[text]]></MsgType>
                            <Content><![CDATA[{3}]]></Content>
                         </xml>";
            }
        }

        /// <summary>
        /// 通过appID和appsecret获取Access_token
        /// -----------------------------------------------------------------------在这个方法里学习如何连接接口
        /// </summary>
        /// <returns></returns>
        private static Access_token GetAccess_token()
        {
            string appid = "wxb1ebabf042f6e8e3";
            string secret = "4241ffc9ad419504e762d0a26ee3f39d";
            string strUrl = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=" + appid + "&secret=" + secret;
            Access_token mode = new Access_token();
            HttpWebRequest req = (HttpWebRequest)HttpWebRequest.Create(strUrl);
            req.Method = "GET";
            using (WebResponse wr = req.GetResponse())
            {
                HttpWebResponse myResponse = (HttpWebResponse)req.GetResponse();
                StreamReader reader = new StreamReader(myResponse.GetResponseStream(), Encoding.UTF8);
                string content = reader.ReadToEnd();//在这里对Access_token 赋值  
                Access_token token = new Access_token();
                token = JsonHelper.ParseFromJson<Access_token>(content);
                mode.access_token = token.access_token;
                mode.expires_in = token.expires_in;
            }
            return mode;
        }
            
        
        //token验证
        public static void token(HttpContext context)
        {
            String token = "test";

            if (string.IsNullOrEmpty(token))
            {
                return;
            }
            String echoStr = context.Request.QueryString["echoStr"];
            String signature = context.Request.QueryString["signature"];
            String timestamp = context.Request.QueryString["timestamp"];
            String nonce = context.Request.QueryString["nonce"];

            context.Response.ContentType = "text/plain";
            context.Response.Write(echoStr);
            context.Response.End();
        }

        //这个是IHTTPHelper的方法，必须实现,意思是是否可以重用，默认为true
        public bool IsReusable
        {
            get { return true; }
        }
    }


    public class Access_token
    {
        public string access_token;
        public string expires_in;
    }

    public class JsonHelper
    {
        public JsonHelper()
        {
            //  
            // TODO: Add constructor logic here  
            //  
        }
        /// <summary>  
        /// 把对象序列化 JSON 字符串   
        /// </summary>  
        /// <typeparam name="T">对象类型</typeparam>  
        /// <param name="obj">对象实体</param>  
        /// <returns>JSON字符串</returns>  
        public static string GetJson<T>(T obj)
        {
            //记住 添加引用 System.ServiceModel.Web   
            /** 
             * 如果不添加上面的引用,System.Runtime.Serialization.Json; Json是出不来的哦 
             * */
            DataContractJsonSerializer json = new DataContractJsonSerializer(typeof(T));
            using (MemoryStream ms = new MemoryStream())
            {
                json.WriteObject(ms, obj);
                string szJson = Encoding.UTF8.GetString(ms.ToArray());
                return szJson;
            }
        }
        /// <summary>  
        /// 把JSON字符串还原为对象  
        /// </summary>  
        /// <typeparam name="T">对象类型</typeparam>  
        /// <param name="szJson">JSON字符串</param>  
        /// <returns>对象实体</returns>  
        public static T ParseFromJson<T>(string szJson)
        {
            T obj = Activator.CreateInstance<T>();
            using (MemoryStream ms = new MemoryStream(Encoding.UTF8.GetBytes(szJson)))
            {
                DataContractJsonSerializer dcj = new DataContractJsonSerializer(typeof(T));
                return (T)dcj.ReadObject(ms);
            }
        }
    }