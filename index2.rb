
require 'nokogiri'
gem 'fast-stemmer'
require 'rubygems'
require 'fast_stemmer'
require 'mechanize'


def write_data(filename, data)
  file = File.open(filename, "w")
  file.puts(data)
  file.close
end

def write_for_newline(filename, data)
 file = File.open(filename, "w")
for entry in data
file.puts(entry)
file.puts("\n")
end
file.close
end

# function that takes the name of a file and loads in the stop words from the file.
#  You could return a list from this function, but a hash might be easier and more efficient.
#  (Why? Hint: think about how you'll use the stop words.)
#
def load_stopwords_file(file) 
    read_file = File.open(file, "r")
    word_hash = Hash.new
    read_file.each_line do |line|
       word_hash[line.chomp]=1
    end
    return word_hash
end



# function that takes the name of a directory, and returns a list of all the filenames in that
# directory.
#
def list_files(dir)
  return Dir[dir + "*"]
end


# function that takes the *name of an html file stored on disk*, and returns a list
#  of tokens (words) in that file. 
#
def find_tokens(filename)   
    f = File.open(filename, 'r')
    #html = IO.read(f).force_encoding("ISO-8859-1").encode("utf-8", replace: nil) #encoding: UTF-8
    html = Nokogiri::HTML(IO.read(f).force_encoding("ISO-8859-1").encode("utf-8", replace: nil))
    begin
	text  = html.at('body').inner_text
	      words = text.scan(/[A-Za-z]+/)
	      	    #words.collect{|x| x.chomp}#strip}
		    rescue
			print "Could not parse through the file " + html.to_s
			end 
			return words
end


# function that takes a list of tokens, and a list (or hash) of stop words,
#  and returns a new list with all of the stop words removed
#
def remove_stop_tokens(tokens, stop_words)
    begin
    for word in tokens
    	if stop_words.has_key?(word)
			tokens.delete(word)
				end
        end
    rescue
    print "Couldn't do remove_stop_tokens"
     end
  return tokens
end


# function that takes a list of tokens, runs a stemmer on each token,
#  and then returns a new list with the stems
#
def stem_tokens(tokens)
    begin
	for word in tokens
	    	 word.downcase!
				word = word.stem
				       word.stem
					end
					rescue
						print "Couldn't do stem_stokens"
						end
    return tokens
end


#
# You'll likely need other functions. Add them here!
#

#################################################
# Main program. We expect the user to run the program like this:
#
#   ruby index.rb pages_dir/ index.dat
#

# The following is just a main program to help get you started.
# Feel free to make any changes or additions/subtractions to this code.
#

# check that the user gave us 3 command line parameters
if ARGV.size != 2
  abort "Command line should have 3 parameters."
end

# fetch command line parameters
(pages_dir, index_file) = ARGV

# read in list of stopwords from file
stopwords = load_stopwords_file("stop.txt")

# get the list of files in the specified directory
file_list = list_files(pages_dir)

	  # create hash data structures to store inverted index and document index
#  the inverted index, and the outgoing links

#build a list of all terms in all the documents
invindex = {}
file_list.each do |doc_name| 
 tokens = find_tokens(doc_name)
  tokens = remove_stop_tokens(tokens, stopwords)
  tokens = stem_tokens(tokens)
 tokens.each do |token|
                token = token.stem
 #               if invindex1.has_key?([token, doc_name])
#		    			       invindex1[[token, doc_name]] = invindex1[[token, doc_name]] + 1
#					       			 else
#										invindex1[[token, doc_name]] = 1
#												  end
												  
													if invindex.has_key?(token)
														if invindex[token].include?(doc_name)
															 a = invindex[token]
															      index = a.index(doc_name)
															      	       invindex[token][index + 1] = a[a.index(doc_name) + 1] + 1
																       			       else
																			          invindex[token] << doc_name
																				  		      invindex[token] << 1
																						      		      	 end
																									  else
																									    invindex[token] = [doc_name, 1]   
																									    		    end
																											       
end
end
print invindex


docindex = {}
file_list.each do |doc_name|
 tokens = find_tokens(doc_name)
sizeof = tokens.size
doc = Nokogiri::HTML(File.open(doc_name))
title = doc.title
url = doc.url

docindex[doc_name] = [sizeof, title, url]
end


 


# scan through the documents one-by-one
$doc_hash = Hash.new


file_list.each do |doc_name|
  print "Parsing HTML document: #{doc_name} \n";
  term_hash = Hash.new
  tokens = find_tokens(doc_name)
  tokens = remove_stop_tokens(tokens, stopwords)
  tokens = stem_tokens(tokens)
  begin
  if term_hash.has_key?(doc_name)
     term.hash[doc_name] = term_hash[doc_name] + 1
     else
	term_hash[doc_name] = 1
	end
  rescue
  end
#print tokens
       begin
	tokens.each do |token|
		       token = token.stem
		       	       if term_hash.has_key?(token)
#memory error if use "<<"		term_hash[token] << doc_name
#	      	 term_hash[token] << doc_name
					term_hash[token] = term_hash[token] + 1
							   else 
										term_hash[token] = 1
												   end
													end
													rescue
														print "Couldn't do tokens.each"
														end
# return $term_hash

$doc_hash[doc_name] = term_hash
end



# save the hashes to the correct files
write_for_newline("invindex.dat", invindex)
write_data("doc.dat", docindex)
# done!


#print $doc_hash
print "Indexing complete!\n";


