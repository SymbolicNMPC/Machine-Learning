pckg := "MachineLearning";
pckgname := "Machine Learning";

ML := cat(pckg,".maple");
PackageTools:-Create(ML);
PackageTools:-SetProperty(ML, "Author", "Behzad Samadi");
PackageTools:-SetProperty(ML, "Item List", "true");
PackageTools:-SetProperty(ML, "X-CloudGroup", "packages");
# PackageTools:-SetProperty(ML, "X-CloudId", "5086116991467520");
PackageTools:-SetProperty(ML, "X-CloudURL", "https://maple.cloud");
PackageTools:-SetProperty(ML, "X-CloudXId", "behzad.samadi@gmail.com");

# Overview
PackageTools:-AddAttachment(ML, "../doc/Overview.mw");

# Examples
PackageTools:-AddAttachment(ML,
                            cat("/Examples/InvertedPendulum/InvertedPendulum.mw") =
                                cat("../examples/InvertedPendulum/InvertedPendulum.mw") );

read cat(pckg, ".mpl");
savelib(convert(pckg,name),ML);

helpfile := cat(pckg, ".help");

HelpTools:-Database:-Create( helpfile );

# MPCDesignTools
makehelp(cat(pckg,"/Overview"),
         cat("../doc/help/MachineLearningOverview.mw"),
         helpfile,
         browser = [pckgname,"Overview"] );

PackageTools:-AddAttachment(ML,
                            cat("/lib/", pckg, ".help") =
                                cat(pckg, ".help") );
