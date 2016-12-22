using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;

class Day22
{
    public static void Main()
    {
        var linesArr = File.ReadAllLines("./input.txt");
        var lines = new List<String>();
        lines.AddRange(linesArr);
        lines.RemoveRange(0, 2); // remove header

        var tuples = lines.Select(line => CreateTuple(line)).ToArray();

        int pairCount = 0;

        for(var i = 0; i < tuples.Length; i++)
        {
            for(var j = i+1; j < tuples.Length; j++)
            {
                var a = tuples[i];
                var b = tuples[j];

                var aIntoB = a.Item2 != 0 && a.Item2 <= b.Item3;
                var bIntoA = b.Item2 != 0 && b.Item2 <= a.Item3;
                if(aIntoB || bIntoA) // a.Used != 0 and a.Used would fit into b.Size
                {
                    pairCount++;
                }
            }   
        }

        Console.WriteLine("The number of viable pairs is: " + pairCount);
    }

    public static Tuple<int, int, int> CreateTuple(string line)
    {
        var parts = line.Split(' ').Where(i => i.Length > 0).ToArray();

        string sizeStr = parts[1];
        int size = Int32.Parse(sizeStr.Remove(sizeStr.Length - 1));

        string usedStr = parts[2];
        int used = Int32.Parse(usedStr.Remove(usedStr.Length - 1));

        string availStr = parts[3];
        int avail = Int32.Parse(availStr.Remove(availStr.Length - 1));

        return new Tuple<int, int, int>(size, used, avail);
    }
}