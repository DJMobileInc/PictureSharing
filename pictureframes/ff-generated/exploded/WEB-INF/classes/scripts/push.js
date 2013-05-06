var ff = require('ffef/FatFractal');
function sendNotification()
{
   data = ff.getExtensionRequestData();
   //get guid of sender
   //sender = data.httpParamaters.sender;
   //receiver = data.httpParamaters.receiver;
//        console.log(" Data "+data);
    
    
   var msg = "Hi!";
   ff.sendPushNotifications(["7TuJG1fpPUbIFyxBHQiRy7"], msg);
}



exports.sendNotification = sendNotification;