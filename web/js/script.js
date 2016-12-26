// JavaScript Document
function parseGetParamsLogin() { 
   var __GET = window.location.search;
   if(__GET != "")
       document.getElementById("errors").innerHTML = "Неверный логин или пароль";
}
function parseGetParamsRegisrt() { 
   var __GET = window.location.search;
   if(__GET != "")
       document.getElementById("errors").innerHTML = "Пользователь с таким логином уже существует";
}

function CheckLogin(){
    var log=document.getElementsByName("login").item(0).value;
    var pass=document.getElementsByName("password").item(0).value;
    if((pass !="")&&(log !=""))
    {
	document.getElementsByName('login-form').item(0).submit(); return false;
    }
    else
        document.getElementById("errors").innerHTML = "Введите логин и пароль";
}
function CheckRegistr(){
	var log=document.getElementsByName("login").item(0).value;
	var pass=document.getElementsByName("pass").item(0).value;
	var pass2=document.getElementsByName("pass2").item(0).value;
	if((log !="")&&(pass !="")&&(pass == pass2))
	{
            document.getElementsByName('registr-form').item(0).submit(); return false;
	}
	else
        {
            if(pass2 != "")
            {
                document.getElementById("errors").innerHTML = "Пароль и подтверждение не совпадают";
            }
            else document.getElementById("errors").innerHTML = "Введите логин, пароль и подтверждение пароля";
        }
}
function AddPhoto()
{
        var imagefile = document.getElementsByName('user_pic').item(0);
        
        document.getElementById("dowload").parentNode.removeChild(document.getElementById("dowload"));
        var imgDow = document.createElement("img");
        
        imgDow.setAttribute("id","dowload");
        document.getElementById("uploadphoto").appendChild(imgDow,document.getElementById("dow"));                    
        document.getElementById("dowload").style.paddingTop = "0"; 
        
        var image = document.getElementById('dowload');
        if(typeof(FileReader)!='undefined')
        {
                var reader = new FileReader();
                reader.onload = function(e){
                        image.src = e.target.result;
                }
                reader.readAsDataURL(imagefile.files.item(0));
        }
        
}
function CheckAdd()
{
	
	var name=document.getElementsByName("name").item(0).value;
	var intname=document.getElementsByName("intname").item(0).value;
        var regions = document.getElementsByName("a");
        var fam = document.getElementsByName("fam").item(0).value;
        var kind = document.getElementsByName("kind").item(0).value;
        var regionSelect = false;
        
        for(var i = 0; i < regions.length; ++i)
        {
            if(regions.item(i).checked == true)
            {
                regionSelect = true;
                break;
            }
        }
    	if((name !="")&&(intname !="")&&(regionSelect)&&(fam != "0")&&(kind != "0")&&(document.getElementById("dowload").tagName == "IMG"))
	{
		document.getElementsByName('add-form').item(0).submit();
        }
	else
	{
		document.getElementById("errors").innerHTML = "Введите всю информацию и выберите картинку";
	}


}
var count_of_select=0;
function Select(obj){
	if(obj.style.backgroundColor == "")
	{
		obj.style.backgroundColor = "#504021";
		obj.getElementsByTagName("input").item(0).value = obj.getElementsByTagName("input").item(0).getAttribute("alt");
		count_of_select++;
		document.getElementById("delete").style.backgroundColor = '#8cb337';
		if(count_of_select==1)
		{
			document.getElementById("redaction").style.backgroundColor = '#8cb337';
		}
		else
			document.getElementById("redaction").style.backgroundColor = '#504021';
	}
	else
	{ 
		obj.style.backgroundColor = "";
		obj.getElementsByTagName("input").item(0).value = "";
		count_of_select--;
		if(count_of_select==0)
		document.getElementById("delete").style.backgroundColor = '#504021';
		if(count_of_select==1)
		{
			document.getElementById("redaction").style.backgroundColor = '#8cb337';
		}
		else
			document.getElementById("redaction").style.backgroundColor = '#504021';
	}
}
function CheckSelectedRedaction()
{
	if(count_of_select==1){
            var elem = document.getElementsByClassName("box");
            var i=elem.item(0).value;
            var j=1;
            for(j; j<elem.length; j++)
            {
                if(elem.item(j).value != "")
                    i=elem.item(j).value;
            }
            window.location.href = '../jsp/redaction.jsp?id=' + i;
            }
	}
function CheckSelectedDelete()
{
	if(count_of_select>0)
		document.getElementsByName('admin-form').item(0).submit();
	
}

function Fill(){
    var otrs = document.getElementsByName("otr").item(0).children;
    var valotr = document.getElementsByName("otr").item(0).title;
    var fam = document.getElementsByName("fam").item(0).children;
    var valfam = document.getElementsByName("fam").item(0).title;
    var kind = document.getElementsByName("kind").item(0).children;
    var valkind = document.getElementsByName("kind").item(0).title;
    var hidreg = document.getElementsByName("hidreg");
    var reg = document.getElementsByName("a");
    for(var i=0;i<reg.length;++i)
    {
        for(var j=0;j<hidreg.length;++j)
        {
            if(reg.item(i).value == hidreg.item(j).value)
            {
                reg.item(i).setAttribute("checked",'');
                break;
            }
        }
    }
    for(var i=0;i<otrs.length;++i)
    {
        if(otrs.item(i).value == valotr)
        {
          otrs.item(i).setAttribute("selected",'')
          break;
      }
    }
    for(var i=0;i<fam.length;++i)
    {
        if(fam.item(i).value == valfam)
        {
          fam.item(i).setAttribute("selected",'')
          break;
      }
    }
    for(var i=0;i<kind.length;++i)
    {
        if(kind.item(i).value == valkind)
        {
          kind.item(i).setAttribute("selected",'')
          break;
      }
    }
    
}


var request;
/*функция создания объекта запроса*/
function CreateRequest()
{
  var request=null;
  try
  {
    //создаем объект запроса для Firefox, Opera, Safari
    request = new XMLHttpRequest();
  }
  catch (e)
  {
    //создаем объект запроса для Internet Explorer
    try
    {       request=new ActiveXObject("Msxml2.XMLHTTP");
    }
    catch (e)
    {
      request=new ActiveXObject("Microsoft.XMLHTTP");
    }
  }
  return request;
}
function OtrLoadResults(){
    if (request.readyState == 4){
    /*Проверяем статус запроса*/
    if (request.status == 200){
      var answer = request.responseText;
      document.getElementsByName("fam").item(0).innerHTML = answer;
      document.getElementsByName("kind").item(0).innerHTML = "<OPTION value='0' selected>Не выбрано</OPTION>";  
    }
  }
}
function ChangeOtr(obj){
    request=CreateRequest();
  /*если не удалось создать объект запроса, то заканчиваем выполнение функции*/
  if(request==null)
  {
    return;
  }
  var url = "../OtrChange" + "?s=" + encodeURIComponent(obj);
  /*настраиваем объект запроса для установки связи*/
  request.onreadystatechange = OtrLoadResults;
  request.open("GET", url, true);
  /*отправляем запрос серверу*/
  request.send(null);
}
function FamLoadResults(){
    if (request.readyState == 4){
    /*Проверяем стат11ус запроса*/
    if (request.status == 200){
      var answer = request.responseText;
      document.getElementsByName("kind").item(0).innerHTML = answer;
    }
  }
}
function ChangeFam(obj){
    request=CreateRequest();
  /*если не удалось создать объект запроса, то заканчиваем выполнение функции*/
  if(request==null)
  {
    return;
  }
  var url = "../FamChange" + "?s=" + encodeURIComponent(obj);
  /*настраиваем объект запроса для установки связи*/
  request.onreadystatechange = FamLoadResults;
  request.open("GET", url, true);
  /*отправляем запрос серверу*/
  request.send(null);
}

function LoadWatch(){
    if (request.readyState == 4){
    /*Проверяем стат11ус запроса*/
    if (request.status == 200){
      var answer = request.responseText;
      document.getElementById("but").innerHTML = "<button onclick='Watch(<%==Id%>)'>Я видел!</button> Видели " + answer + " человек";
    }
  }
}
function Watch(obj){
    request=CreateRequest();
  /*если не удалось создать объект запроса, то заканчиваем выполнение функции*/
  if(request==null)
  {
    return;
  }
  var url = "../Watch?bird=" + obj;
  /*настраиваем объект запроса для установки связи*/
  request.onreadystatechange = LoadWatch;
  request.open("GET", url, true);
  /*отправляем запрос серверу*/
  request.send(null);
}

function LoadSearch(){
    if (request.readyState == 4){
    /*Проверяем стат11ус запроса*/
    if (request.status == 200){
      var answer = request.responseText;
      document.getElementsByClassName("view").item(0).innerHTML = answer;
    }
  }
}
function KeyPress(obj)
{
    request=CreateRequest();
  /*если не удалось создать объект запроса, то заканчиваем выполнение функции*/
  if(request==null)
  {
    return;
  }
  var url = "../Search?s=" + obj;
  /*настраиваем объект запроса для установки связи*/
  request.onreadystatechange = LoadSearch;
  request.open("GET", url, true);
  /*отправляем запрос серверу*/
  request.send(null);
}
/*function Delete()
{/*
	var arr = document.getElementsByClassName("photo-bird-all");
	var elem;
	for(var i=0; i<arr.length;++i )
	{
            if(arr.item(i).style.backgroundColor != "")
            {
		elem = arr.item(i);
		elem.parentNode.removeChild(elem);
		i--;
            }
	}*/
       // document.getElementsByName('admin-form').item(0).submit();
	//document.forms[0].submit();
//}


























