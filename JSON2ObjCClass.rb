# Copyright (c) 2013 Kevin Cathaly
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#!/usr/bin/env ruby
require 'rubygems'
require 'json'

jsonFileName = "yourJsonFile.json"

def parseJson(variable, declarationFile, implementationFile)
	variable.keys.each do |key|
		unless variable[key].is_a?(Hash) && variable[key].is_a?(Array)
			if variable[key].is_a?(Integer)
				declarationFile.puts("@property (assign, nonatomic) int #{key};")
				implementationFile.puts("\t\t_#{key} = [dico[@\"#{key}\"] intValue];")
			elsif variable[key].is_a?(String)
				declarationFile.puts("@property (strong, nonatomic) NSString *#{key};")
				implementationFile.puts("\t\t_#{key} = dico[@\"#{key}\"];")
			elsif variable[key].is_a?(Float)
				declarationFile.puts("@property (strong, nonatomic) float #{key};")
				implementationFile.puts("\t\t_#{key} = [dico[@\"#{key}\"] floatValue];")
			elsif variable[key].is_a?(FalseClass) || variable[key].is_a?(TrueClass)
				declarationFile.puts("@property (strong, nonatomic) BOOL #{key};")
				implementationFile.puts("\t\t_#{key} = [dico[@\"#{key}\"] boolValue];")
			else
				puts "UNKNOWN CLASS #{variable} -> #{variable[key]} :: #{variable[key].class.name}"
			end
		else
			#ADD NSArray and NSDictionary 
		end
	end
end


header = File.new("Model.h", "w")
header.puts("#import <Foundation/Foundation.h>")
header.puts("\n@interface Model : NSObject \n ")


implementation = File.new("Model.m", "w")
implementation.puts("#import \"Model.h\"")
implementation.puts("\n@interface Model ()")
implementation.puts("\n@end")
implementation.puts("\n\n@implementation Model")
implementation.puts("\n- (id)initWithDictionary:(NSDictionary *)dico\n{")
implementation.puts("\tself = [super init];\n\tif (self) {")

file = File.open(jsonFileName = "yourJsonFile.json")
contents = file.read
data = JSON.parse(contents)
parseJson(data, header, implementation) 



header.puts("\n- (id)initWithDictionary:(NSDictionary *)dico;")
header.puts("\n@end")
header.close

implementation.puts("\t}\n}")
implementation.puts("\n@end")
implementation.close
