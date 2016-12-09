String input = new File("input.txt").text;

int i = 0;
while(input.length() > 0) {
    def m = (input =~ /^\((\d+)x(\d+)\)/)
    if(m.count > 0) {   
        def size = m[0][1] as Integer
        def repeat = m[0][2] as Integer

        def markerLength = ("(${size}x${repeat})").length()    
        
        def realsize = Math.min(size, input.substring(markerLength).length())
        i += realsize * repeat
        input = input.substring(markerLength + realsize)       
    }
    else {
        i++
        input = input.substring(1)
    }
}

println "The decompressed character count is $i"