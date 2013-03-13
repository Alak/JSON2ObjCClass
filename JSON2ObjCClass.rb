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
header.puts("\n@interface Model : NSObject \n")
header.puts("")

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
