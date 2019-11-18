import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.mapred.TextInputFormat;
import org.apache.hadoop.mapred.TextOutputFormat;
import org.apache.hadoop.mapred.FileInputFormat;
import org.apache.hadoop.mapred.FileOutputFormat;
import org.apache.hadoop.mapred.JobClient;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapred.MapReduceBase;
import org.apache.hadoop.mapred.Mapper;
import org.apache.hadoop.mapred.OutputCollector;
import org.apache.hadoop.mapred.Reducer;
import org.apache.hadoop.mapred.Reporter;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;
  
public class LondonCrimes {
  public static class MapOutcomes extends MapReduceBase implements Mapper<LongWritable, Text, Text, IntWritable> {
    private final static IntWritable increment = new IntWritable(1);
    private Text name = new Text();

    public void map(LongWritable key, Text value, OutputCollector<Text, IntWritable> output, Reporter reporter) throws IOException {
      String record = value.toString();
      String values[] = record.split(",");
      name.set(values[9]);
      output.collect(name, increment);
    }
  }

  public static class ReduceOutcomes extends MapReduceBase implements Reducer<Text, IntWritable, Text, IntWritable> {
    public void reduce(Text key, Iterator<IntWritable> values, OutputCollector<Text, IntWritable> output, Reporter reporter) throws IOException {
      int sum = 0;
      while (values.hasNext()) {
          sum += values.next().get();
      }
      output.collect(key, new IntWritable(sum));
    }
  }

  public static class MapSolved extends MapReduceBase implements Mapper<LongWritable, Text, Text, Text>{
    private Text date = new Text();
    private Text data = new Text();

    public void map(LongWritable key, Text value, OutputCollector<Text, Text> output, Reporter reporter) throws IOException{
      String[] rows = value.toString().split(",");
      String date_text = rows[1];

      if (!date_text.contains("Month")){
        int solved = 1;
        String resolution_text = rows[9];
        
        if (resolution_text.contains("no suspect identified")){
          solved = 0;
        }
  
        date.set(date_text);
        data.set(1 + "\t" + solved);
        output.collect(date, data);
      }
    }
  }

  public static class ReduceSolved extends MapReduceBase implements Reducer<Text, Text, Text, Text> {
    public void reduce(Text key, Iterator<Text> values, OutputCollector<Text, Text> output, Reporter reporter) throws IOException {
      int numSolved = 0;
      int numTotal = 0;

      while(values.hasNext()){
        String data_array[] = (values.next().toString()).split("\t");
        int solved = Integer.parseInt(data_array[1]);
        
        if(solved > 0){
          numSolved++;
        }
        numTotal++;
      }

      output.collect(key, new Text(numTotal + "\t" + numSolved + "\t" + ((100*numSolved)/numTotal) + "%"));
    }
  }

  public static class MapLocations extends MapReduceBase implements Mapper<LongWritable, Text, Text, IntWritable> {
    private final static IntWritable increment = new IntWritable(1);
    private Text name = new Text();

    public void map(LongWritable key, Text value, OutputCollector<Text, IntWritable> output, Reporter reporter) throws IOException {
      String record = value.toString();
      String values[] = record.split(",");
      name.set(values[6]);
      output.collect(name, increment);
    }
  }

  public static class ReduceLocations extends MapReduceBase implements Reducer<Text, IntWritable, Text, IntWritable> {
    public void reduce(Text key, Iterator<IntWritable> values, OutputCollector<Text, IntWritable> output, Reporter reporter) throws IOException {
      int sum = 0;
      while (values.hasNext()) {
          sum += values.next().get();
      }
      output.collect(key, new IntWritable(sum));
    }
  }

  public static void main(String[] args) throws IOException{
    JobConf conf = new JobConf(LondonCrimes.class);

    conf.setJobName("LondonCrimes:"+args[2]);

    conf.setOutputKeyClass(Text.class);
    conf.setOutputValueClass(Text.class);

    if (args[2].contains("solved")){
      conf.setMapperClass(MapSolved.class);
      conf.setReducerClass(ReduceSolved.class);
    } else if (args[2].contains("location")){
      conf.setMapperClass(MapLocations.class);
      conf.setReducerClass(ReduceLocations.class);
      conf.setOutputValueClass(IntWritable.class);
    } else {
      conf.setMapperClass(MapOutcomes.class);
      conf.setReducerClass(ReduceOutcomes.class);
      conf.setOutputValueClass(IntWritable.class);
    }

    conf.setInputFormat(TextInputFormat.class);
    conf.setOutputFormat(TextOutputFormat.class);

    FileInputFormat.setInputPaths(conf, new Path(args[0]));
    FileOutputFormat.setOutputPath(conf, new Path(args[1]));

    JobClient.runJob(conf);
  }
}
