var fs = require('fs'), path = require('path');

function getProjectName() {
    var config = fs.readFileSync('config.xml').toString();
    var parseString = require('xml2js').parseString;
    var name;
    parseString(config, function (err, result) {
        name = result.widget.name.toString();
        const r = /\B\s+|\s+\B/g;  //Removes trailing and leading spaces
        name = name.replace(r, '');
    });
    return name || null;
}

module.exports = function(context) {
      var projectName = getProjectName();
      var appDelegate = path.join(context.opts.projectRoot, "platforms", "ios", projectName, "Classes", "AppDelegate.h");   
    if (fs.existsSync(appDelegate)) {
     
      fs.readFile(appDelegate, 'utf8', function (err,data) {
        
        if (err) {
          throw new Error('🚨 Unable to read AppDelegate: ' + err);
        }
        
        var result = data;
        var shouldBeSaved = false;

        if (!data.includes("isPairedWatchExist")){
          shouldBeSaved = true;
          result = data.replace(/CDVAppDelegate.h>/g, "CDVAppDelegate.h>\n#import <WatchConnectivity/WatchConnectivity.h>");
          result = result.replace(/@end/g, "@property (strong,nonatomic) WCSession *session;\n@property (assign,nonatomic) BOOL isPairedWatchExist;\n\n@end");
        } else {
          console.log("🚨 AppDelegate already modified");
        }

        if (shouldBeSaved){
          fs.writeFile(appDelegate, result, 'utf8', function (err) {
          if (err) 
            {throw new Error('🚨 Unable to write into AppDelegate: ' + err);}
          else 
            {console.log("✅ AppDelegate edited successfuly");}
        });
        }

      });
    } else {
        throw new Error("🚨 WARNING: AppDelegate was not found. The build phase may not finish successfuly");
    }
  }
