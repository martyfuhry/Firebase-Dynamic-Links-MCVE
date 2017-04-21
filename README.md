# Firebase-Dynamic-Links-MCVE
Using the deep link:
```
https://s8x25.app.goo.gl/?link=https://www.reportallusa.com/survey&apn=com.reportallusa.landglide&isi=560902465&ibi=com.reportallusa.landglide.Landglide
```

![Alt text](/screenshots/screenshot_dynamic_link_normal.png?raw=true "Expected Dynamic Link Behavior")
This is the proper behavior when the dynamic link is opened when the app is already installed. It works fine in this case. See how the link parameter is properly embedded:
```
https://www.reportallusa.com/survey
```

![Alt text](/screenshots/screenshot_dynamic_link_first_open.png?raw=true "Dynamic Link First Open")
This is the behavior when the dynamic link is opened when the app is not already installed. Notice the lack of any link parameter data::
```
//google/link/
```

Missing is the embedded link parameter 
```
link=https://www.reportallusa.com/survey
```

The expected link should look like: 
```
//google/link?link=https://www.reportallusa.com/survey
```
