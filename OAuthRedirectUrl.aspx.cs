using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
//xml
using System.Xml;
using System.Xml.Linq;
using System.IO;
using System.Text;
//序列化，json
using System.Runtime.Serialization;
using System.ServiceModel.Web;
using System.Runtime.Serialization.Json;

public partial class OAuthRedirectUrl : System.Web.UI.Page
{
    string appid = "wxb1ebabf042f6e8e3";
    string secret = "4241ffc9ad419504e762d0a26ee3f39d";
    protected void Page_Load(object sender, EventArgs e)
    {
        //如果不是POST提交（也就是第一次进入该页面）,则初始化页面或控件等等
        if(!IsPostBack)
        {
            String reUrl = Request.QueryString["reurl"];
            String code = Request.QueryString["code"];
            OAuth_token token = Get_token(code);
            UserInfo info = Get_info(token);

            String redirectUrl = "http://jsu7g5.natappfree.cc/index.aspx";

            Session.Add("info", JsonHelper.GetJson<UserInfo>(info));
            //Server.Transfer(redirectUrl);
            Response.Redirect(redirectUrl);
        }
    }
    protected OAuth_token Get_token(String code)
    {
        OAuth_token mode = new OAuth_token();
        String url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid="+appid+"&secret="+secret+"&code="+code+"&grant_type=authorization_code";
        HttpWebRequest req = HttpWebRequest.Create(url) as HttpWebRequest;
        req.Method = "GET";
        using(HttpWebResponse res = req.GetResponse() as HttpWebResponse)
        {
            StreamReader reader = new StreamReader(res.GetResponseStream(), Encoding.UTF8);
            String content = reader.ReadToEnd();
            mode = JsonHelper.ParseFromJson<OAuth_token>(content);
        }

        return mode;
    }
    protected UserInfo Get_info(OAuth_token token)
    {
        UserInfo mode =new UserInfo();
        String url = "https://api.weixin.qq.com/sns/userinfo?access_token="+token.access_token+"&openid="+token.openid+"&lang=zh_CN";
        HttpWebRequest req = HttpWebRequest.Create(url) as HttpWebRequest;
        req.Method = "GET";
        using (HttpWebResponse res = req.GetResponse() as HttpWebResponse)
        {
            StreamReader reader = new StreamReader(res.GetResponseStream(), Encoding.UTF8);
            String content = reader.ReadToEnd();
            mode = JsonHelper.ParseFromJson<UserInfo>(content);
        }

        return mode;
    }
    public class OAuth_token
    {
        public String access_token;
        public String expires_in;
        public String refresh_token;
        public String openid;
        public String scope;
    }
    public class UserInfo
    {
        public String openid;
        public String nickname;
        public String sex;
        public String province;
        public String city;
        public String country;
        public String headimgurl;
        public String privilege;
        public String unionid;
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
}