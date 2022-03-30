import os
import sys
import re

packages_to_seacrh=[]+sys.argv[1:]
required_packages=[]+sys.argv[1:]

while packages_to_seacrh:
    package_to_seacrh=packages_to_seacrh.pop()
    print "searching dependency for package {}".format(package_to_seacrh)
    p=os.popen("yum deplist '{}' 2>/dev/null ".format(package_to_seacrh))
    content=p.read()
    p.close()
    
    content=content.split("\n")
    content_rid=0
    while content_rid < len(content):
        current_line=content[content_rid]
        print "current_line: {}".format(current_line)
        
        matchObj = re.match(r'.*dependency: (.*)', current_line)
        if matchObj:
            content_rid+=1
            is_first=True
            while content_rid < len(content):

                current_line=content[content_rid]
                matchObj = re.match(r'.*provider: (.*)', current_line)
                if matchObj:
                    print "found provider: {}".format(current_line)
                    if is_first:
                        is_first=False
                        provider_package = matchObj.group(1)
                        print "provider package is {}".format(provider_package)
                        if not provider_package in required_packages:
                            print "new package to search {}".format(provider_package)
                            required_packages.append(provider_package)
                            packages_to_seacrh.append(matchObj.group(1))
                else:
                    break
                content_rid+=1
            
        else:
            print "skip this row"
        content_rid+=1
        
    
print "going to download the required packages:\n"+",".join(required_packages)

for package in required_packages:
    print "downloading package: {}".format(package)
    os.system("yum download '{}'".format(package))

