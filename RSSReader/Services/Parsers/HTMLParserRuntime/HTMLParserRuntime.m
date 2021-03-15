//
//  HTMLParserRuntime.m
//  RSSReader
//
//  Created by Uladzislau Stankevich on 15.03.21.
//

#import "HTMLParserRuntime.h"
#import <objc/message.h>
#import "SearchFeedItem.h"

NSString *const kRSSPattern = @"<link[^>]+type=\"application/rss\\+xml\".*?>";
NSString *const kTitlePattern = @"title=\"(.*?)\"";
NSString *const kHrefPattern = @"href=\"(.*?)\"";
NSString *const kName = @"className";
NSString *const kRssRegExSelector = @"rssRegEx";
NSString *const kTitleRegExSelector = @"titleRegEx";
NSString *const kHrefRegExSelector = @"hrefRegEx";
NSString *const kSiteNameSelector = @"siteName";
NSString *const kParseMatchSelector = @"parseMatch:";
NSString *const kFindSubstringSelector = @"findSubstringWithPattern:originalString:";
NSString *const kParseHTMLSelector = @"parseHTML:array:sitename:";
NSString *const kHttph = @"http";

char* className = "HTMLParserRuntime";
char* rssRegExRuntimeIvar = "_rssRegEx";
char* titleRegExRuntimeIvar = "_titleRegEx";
char* hrefRegExRuntimeIvar = "_hrefRegEx";
char* siteNameRegExRuntimeIvar = "_siteName";

Class registerHTMLParser() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class htmlParser = objc_allocateClassPair([NSObject class], kName.UTF8String, 0);
        
        class_addIvar(htmlParser, rssRegExRuntimeIvar, sizeof(id), log2(sizeof(id)), @encode(id));
        class_addIvar(htmlParser, titleRegExRuntimeIvar, sizeof(id), log2(sizeof(id)), @encode(id));
        class_addIvar(htmlParser, hrefRegExRuntimeIvar, sizeof(id), log2(sizeof(id)), @encode(id));
        class_addIvar(htmlParser, siteNameRegExRuntimeIvar, sizeof(id), log2(sizeof(id)), @encode(id));
        
        Ivar _rssRegEx_ivar = class_getInstanceVariable(htmlParser, rssRegExRuntimeIvar);
        Ivar _titleRegEx_ivar = class_getInstanceVariable(htmlParser, titleRegExRuntimeIvar);
        Ivar _hrefRegEx_ivar = class_getInstanceVariable(htmlParser, hrefRegExRuntimeIvar);
        Ivar _siteName_ivar = class_getInstanceVariable(htmlParser, siteNameRegExRuntimeIvar);
        
        IMP _rssRegEx_imp = imp_implementationWithBlock(^id(id self){
            id _rssRegEx_ref = object_getIvar(self, _rssRegEx_ivar);
            if (!_rssRegEx_ref) {
                NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
                id newValue = [[NSRegularExpression alloc] initWithPattern:kRSSPattern options:regexOptions error:nil];
                
                object_setIvarWithStrongDefault(self, _rssRegEx_ivar, [newValue autorelease]);
                [newValue release];
                return object_getIvar(self, _rssRegEx_ivar);
                
            }
            return _rssRegEx_ref;
        });
        class_addMethod(htmlParser, NSSelectorFromString(kRssRegExSelector), _rssRegEx_imp, "@@:");
        
        IMP _titleRegEx_imp = imp_implementationWithBlock(^id(id self) {
            id _titleRegEx_ref = object_getIvar(self, _titleRegEx_ivar);
            if (!_titleRegEx_ref) {
                NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
                id newValue = [[NSRegularExpression alloc] initWithPattern:kTitlePattern options:regexOptions error:nil];
                
                object_setIvarWithStrongDefault(self, _titleRegEx_ivar, [newValue autorelease]);
                [newValue release];
                return object_getIvar(self, _titleRegEx_ivar);
                
            }
            return _titleRegEx_ref;
        });
        class_addMethod(htmlParser, NSSelectorFromString(kTitleRegExSelector), _titleRegEx_imp, "@@:");
        
        
        IMP _hrefRegEx_imp = imp_implementationWithBlock(^id(id self){
            id _hrefRegEx_ref = object_getIvar(self, _hrefRegEx_ivar);
            if (!_hrefRegEx_ref) {
                NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
                id newValue = [[NSRegularExpression alloc] initWithPattern:kHrefPattern options:regexOptions error:nil];
                
                object_setIvarWithStrongDefault(self, _hrefRegEx_ivar, [newValue autorelease]);
                [newValue release];
                return object_getIvar(self, _hrefRegEx_ivar);
                
            }
            return _hrefRegEx_ref;
        });
        class_addMethod(htmlParser, NSSelectorFromString(kHrefRegExSelector), _hrefRegEx_imp, "@@:");
        
        IMP parseHTMLArray = imp_implementationWithBlock(^(id self, NSString *htmlString, NSMutableArray<SearchFeedItem *> *array, NSString *siteName){
            
            if (![self respondsToSelector:NSSelectorFromString(kSiteNameSelector)]) {
                IMP _siteName_imp = imp_implementationWithBlock(^id(id self) {
                    id _siteName_ref = object_getIvar(self, _siteName_ivar);
                    if (!_siteName_ref) {
                        object_setIvarWithStrongDefault(self, _siteName_ivar, siteName);
                        return object_getIvar(self, _siteName_ivar);
                        
                    }
                    return _siteName_ref;
                });
                class_addMethod(htmlParser, NSSelectorFromString(kSiteNameSelector), _siteName_imp, "@@:");
            }
            else {
                object_setIvar(self, _siteName_ivar, siteName);
            }
            
            
            
            id rssRegEx = [self performSelector:NSSelectorFromString(kRssRegExSelector)];
            NSArray* matches = [rssRegEx matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
            
            for ( NSTextCheckingResult* match in matches )
            {
                NSString* matchText = [htmlString substringWithRange:[match range]];
                SEL parseMatch = NSSelectorFromString(kParseMatchSelector);
                [array addObject: [self performSelector:parseMatch withObject:matchText]];
                
            }
        });
        
        class_addMethod(htmlParser, NSSelectorFromString(kParseHTMLSelector), parseHTMLArray, "@@:");
        
        IMP parseMatch = imp_implementationWithBlock(^(id self, NSString *match){
            
            SEL findSubstringWithPatternSel = NSSelectorFromString(kFindSubstringSelector);
            NSString *title = [self performSelector:findSubstringWithPatternSel withObject:kTitlePattern withObject:match];
            NSString *url = [self performSelector:findSubstringWithPatternSel withObject:kHrefPattern withObject:match];
            
            if (![url containsString:kHttph]) {
                id siteName = [self performSelector:NSSelectorFromString(kSiteNameSelector)];
                url = [NSString stringWithFormat:@"%@%@",siteName, url];
            }
            
            SearchFeedItem *item = [SearchFeedItem new];
            item.title = title;
            item.url = url;
            return [item autorelease];
            
        });
        
        class_addMethod(htmlParser, NSSelectorFromString(kParseMatchSelector), parseMatch, "@@:");
        
        IMP findSubstringWithPattern = imp_implementationWithBlock(^(id self, NSString *pattern, NSString *originalString){
            NSArray *matches;
            if ([pattern isEqualToString:kTitlePattern]) {
                id titleRegEx =  [self performSelector:NSSelectorFromString(kTitleRegExSelector)];
                matches = [titleRegEx matchesInString:originalString options:0 range:NSMakeRange(0, [originalString length])];
            }
            else {
                id hrefRegEx =  [self performSelector:NSSelectorFromString(kHrefRegExSelector)];
                matches = [hrefRegEx matchesInString:originalString options:0 range:NSMakeRange(0, [originalString length])];
            }
            NSRange matchRange = [matches[0] rangeAtIndex:1];
            return [originalString substringWithRange:matchRange];
        });
        
        class_addMethod(htmlParser, NSSelectorFromString(kFindSubstringSelector), findSubstringWithPattern, "@@:");
        objc_registerClassPair(htmlParser);
        
    });
    return NSClassFromString(kName);
}
