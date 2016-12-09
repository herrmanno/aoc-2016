String input = new File("input.txt").text;

long decompress(String input) {
    long i = 0;
    while(input.length() > 0) {
        def m = (input =~ /^\((\d+)x(\d+)\)/)
        if(m.count > 0) {   
            def size = m[0][1] as Integer
            def repeat = m[0][2] as Integer
            
            def markerLength = ("(${size}x${repeat})").length()    
            def realsize = Math.min(size, input.substring(markerLength).length())
            
            def substr = input.substring(markerLength, markerLength + realsize)
            def subCount = decompress(substr)
            
            i += repeat * subCount
            input = input.substring(markerLength + realsize)       
        }
        else {
            i++
            input = input.substring(1)
        }
    }

    return i
}

long count = decompress(input)
println "The v.2 decompressed characater count is $count"