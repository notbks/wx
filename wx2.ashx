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
//数据库
using System.Data;
using System.Data.SqlClient;
//多线程
using System.Threading;


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

                AT = GetAccess_token();
                string isOK =createMenu(AT);
                //string isOK = "ooooo";
                //string isOK = DBUtil.select("select name from dbo.table_1 where id=2;");
            //    String sql = "insert into dbo.access_token (create_date, access_token, expires_in, status, lapse_date) "
            //+ "values ('" + DateTime.Now.Ticks
            //+ "', '" + AT.access_token + "', '" + AT.expires_in + "', 1, '');";
            //    String isOK = DBUtil.insert(sql).ToString();
                //String getCreate_date = "select create_date from dbo.access_token where id=7;";
                //String isOK = DBUtil.select(getCreate_date);

                
                
                using (Stream stream = context.Request.InputStream)
                {
                    Byte[] postBytes = new Byte[stream.Length];
                    stream.Read(postBytes, 0, (Int32)stream.Length);
                    postString = Encoding.UTF8.GetString(postBytes);

                    if (!string.IsNullOrEmpty(postString))
                    {
                        /// 处理信息并应答
                        String responseContent = returnMessage(postString, AT, isOK);
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
        /// 创建自定义菜单
        /// </summary>
        /// <param name="AT"></param>
        /// <returns></returns>
        public static string  createMenu(Access_token AT)
        {
            string isOK ="";
            String data ="";
            //1：自定义创建菜单接口，需要access_token
            string strUrl = "https://api.weixin.qq.com/cgi-bin/menu/create?access_token=" + AT.access_token;
            //2：创建访问这个路径的request对象，并设置请求方法，必须是post，设置请求头
            HttpWebRequest req = (HttpWebRequest)HttpWebRequest.Create(strUrl);
            req.Method = "POST";
            req.ContentType = "application/x-www-form-urlencoded";
            //3：从txt中读取自定义菜单--------------------------------------------------------------------------------用StreamReader读取路径
            StreamReader sr =null;
            try
            {
                sr = new StreamReader("C:/inetpub/wwwroot/menu.txt");
                data = sr.ReadToEnd();
            }
            catch(Exception e)
            {
                isOK =e.GetType().Name;
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();    
                }
            }
            //4：将json数据转化为数据流，存入request中
            byte[] dataBytes =Encoding.UTF8.GetBytes(data);
            req.ContentLength = dataBytes.Length;
            Stream writer =req.GetRequestStream();
            writer.Write(dataBytes, 0, dataBytes.Length);
            writer.Close();
            //5：执行request，得到response----------再用reader读取返回结果
            var result = (HttpWebResponse)req.GetResponse();
            StreamReader reader = new StreamReader(result.GetResponseStream(), Encoding.UTF8);
            isOK = reader.ReadToEnd();
            return isOK;
    }
        
        
        /// <summary>
        /// 处理消息的方法
        /// </summary>
        /// <param name="postStr"></param>
        /// <returns></returns>
        public static string returnMessage(String postStr, Access_token AT, string  isOK)
        {
            XmlDocument xmlDoc = new XmlDocument();
            String responseContent = "";
            String say =isOK;
            try
            {
                //读取请求里的xml
                xmlDoc.Load(new System.IO.MemoryStream(System.Text.Encoding.UTF8.GetBytes(postStr)));
                //获取各个子节点
                XmlNode toUserName = xmlDoc.SelectSingleNode("/xml/ToUserName");
                XmlNode fromUserName = xmlDoc.SelectSingleNode("/xml/FromUserName");
                XmlNode msgType = xmlDoc.SelectSingleNode("/xml/MsgType");
                
                //click事件
                if(msgType.InnerText =="event")
                {
                        XmlNode eventType = xmlDoc.SelectSingleNode("/xml/Event");
                        switch(eventType.InnerText)
                        {
                            case "subscribe":
                                say = "谢谢关注！回复'音乐',一首暖暖送给你";
                                break;
                            case "CLICK":
                                XmlNode eventKey = xmlDoc.SelectSingleNode("/xml/EventKey");
                                switch(eventKey.InnerText)
                                {
                                    case "giveAMenu1":
                                        responseContent = string.Format(Message_pic, fromUserName.InnerText, toUserName.InnerText, DateTime.Now.Ticks, "4399欢迎你", "23333333", "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1521455918828&di=9d5f285ef8af1fc57c2fb3f2f86d7a2e&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01dc3558d0c8b0a801219c77d1ac82.jpg%40900w_1l_2o_100sh.jpg", "http://www.4399.com");
                                        goto cc;
                                    case "giveALike":
                                        say = "谢谢...虽然没用，打算做一个计数界面，记录点赞总数";
                                        break;
                                    default:
                                        say = "?????";
                                        break;
                                }
                                break;
                            default:
                                say = "未处理";
                                break;
                        }
                }//文字消息   
                else if(msgType.InnerText == "text"){
                    XmlNode content = xmlDoc.SelectSingleNode("/xml/Content");
                    switch(content.InnerText)
                    {
                        case "你好":
                            say = "你也好";
                            break;
                        case "音乐":
                            responseContent = string.Format(Message_pic, fromUserName.InnerText, toUserName.InnerText, DateTime.Now.Ticks, "一首暖暖送给你", "祝你万事如意", "http://singerimg.kugou.com/uploadpic/softhead/240/20160728/20160728235333363212.jpg", "http://www.kugou.com/song/c8s1n14.html?frombaidu#hash=5953B05DF61C794D9CA8B24365012658&album_id=0");
                            goto cc;
                        default:
                            say = isOK;
                            break;
                    }
                }
  
  
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
  
            cc:return responseContent;
            
        }
        /// <summary>
        /// 普通文本消息,xml--------------------------------------------------------------------------C#的特色
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
        //图片消息
        public static string Message_pic
        {
            get
            {
                return @"<xml>
                            <ToUserName><![CDATA[{0}]]></ToUserName>
                            <FromUserName><![CDATA[{1}]]></FromUserName>
                            <CreateTime>{2}</CreateTime>
                            <MsgType><![CDATA[news]]></MsgType>
                            <ArticleCount>1</ArticleCount>
                            <Articles>
                                <item>
                                    <Title><![CDATA[{3}]]></Title>
                                    <Description><![CDATA[{4}]]></Description>
                                    <PicUrl><![CDATA[{5}]]></PicUrl>
                                    <Url><![CDATA[{6}]]></Url>
                                </item>
                            </Articles>
                        </xml>";
            }
        }

        /// <summary>
        /// 通过appID和appsecret获取Access_token.并优化access_token的存储
        /// -----------------------------------------------------------------------在这个方法里学习如何连接接口
        /// </summary>
        /// <returns></returns>
        private static Access_token GetAccess_token()
        {
            Access_token mode = new Access_token();
            String getCreate_date = "select create_date from dbo.access_token where id=7;";
            String create_date =DBUtil.select(getCreate_date);
            long time1 =Convert.ToInt64(create_date)+7100000;
            long time2 =DateTime.Now.Ticks;
            //如果已经失效就新建并更新access_token的数据库信息，如果还没失效就从数据库读取
            if(time1 <time2)
            {
                string appid = "wxb1ebabf042f6e8e3";
                string secret = "4241ffc9ad419504e762d0a26ee3f39d";
                string strUrl = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=" + appid + "&secret=" + secret;

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
                    //更新数据库
                    String updateAccess_token = "UPDATE dbo.access_token SET create_date ='" + DateTime.Now.Ticks + "', access_token='" + mode.access_token + "' WHERE id=7;";
                    DBUtil.update(updateAccess_token);
                }
            }
            else
            {
                String getAccess_token = "select access_token from dbo.access_token where id=7;";
                mode.access_token = DBUtil.select(getAccess_token);
                mode.expires_in = "7200";
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

    public class DBUtil
    {
        static String connPath = "server=ZHENGNIU002;database=test;uid=sa;password=123456";
        static SqlConnection conn;
        static SqlCommand comm;
        static SqlDataAdapter adapter;
        static DataSet set = new DataSet();

        //更新
        public static int update(String sql)
        {
            int result;
            using (conn = new SqlConnection(connPath))
            {
                comm = new SqlCommand(sql, conn);
                conn.Open();

                result = comm.ExecuteNonQuery();

            }
            return result;
        }
        //删除
        public static int delete(String sql)
        {
            int result;
            using (conn = new SqlConnection(connPath))
            {
                comm = new SqlCommand(sql, conn);
                conn.Open();

                result = comm.ExecuteNonQuery();

            }
            return result;
        }
        //插入
        public static int insert(String sql)
        {
            int result;
            using (conn = new SqlConnection(connPath))
            {
                comm = new SqlCommand(sql, conn);
                conn.Open();

                result = comm.ExecuteNonQuery();

            }
            return result;
        }
        //查询
        public static String select(String sql)
        {
            String result = "";
            using (conn = new SqlConnection(connPath))
            {
                adapter = new SqlDataAdapter(sql, conn);
                conn.Open();

                adapter.Fill(set, "t1");
                //获取第一行的数据
                DataRow row = set.Tables["t1"].Rows[0];
                //列的数量
                int column = set.Tables["t1"].Columns.Count;
                //循环遍历这一行的数据,这样不管数据库有几列，都没问题
                for (int i = 0; i < column; i++)
                {
                    result = Convert.ToString(row[i])+" ";
                }

            }
            return result;
        }
        //查询整张表
        public static DataSet selectAll()
        {
            String sql = "select * from dbo.table_1;";

            using (conn = new SqlConnection(connPath))
            {
                //这里用adapter
                adapter = new SqlDataAdapter(sql, conn);
                conn.Open();
                //将数据填入set，并命名为t1
                adapter.Fill(set, "t1");

            }
            return set;
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