<%-- 
    Document   : prediction
    Created on : 06-Mar-2021, 12:31:18
    Author     : David Adeyinka
--%>

<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.FileReader"%>
<%@page import="weka.classifiers.trees.J48"%>
<%@page import="weka.core.Instances"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Types"%>
<%@page import="com.mysql.jdbc.PreparedStatement"%>
<%@page import="com.mysql.jdbc.Connection"%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    try {
        String category = request.getParameter("Category").toString();
        String currency = request.getParameter("currency").toString();
        String duration = request.getParameter("Duration").toString();
        String endDay = request.getParameter("endDay").toString();
        
        String toPredict = "?";
        DriverManager.registerDriver(new com.mysql.jdbc.Driver());
        Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost:3306/auction", "root", "");
        String statement = "INSERT INTO `auction_table` VALUES (?, ?, ?, ?, ?, ?)";
        
        String predictFilePath = "C:\\Users\\ddune\\Documents\\AuctionPrediction.arff";
        BufferedWriter predictWriter = new BufferedWriter(new FileWriter(predictFilePath));
        predictWriter.write(
               "@relation Project1DataTrain\n"+
"\n"+
"@attribute Category {Music, Movie, Games}\n"+
"@attribute currency {US, GBP, EUR}\n"+
"@attribute Duration {Five, One, seven, Three, Ten}\n"+
"@attribute endDay {Mon, Tue, Wed, Thu, Fri, Sat, Sun}\n"+
"@attribute Competitive {TRUE, FALSE}\n"+
                       "\n"+
                "@data"
        );
        predictWriter.close();
        FileWriter predictFileWriter = new FileWriter(predictFilePath, true);
        predictFileWriter.write("\n");
        predictFileWriter.write(category);
        predictFileWriter.write(",");
        predictFileWriter.write(currency);
        predictFileWriter.write(",");
        predictFileWriter.write(duration);
        predictFileWriter.write(",");
        predictFileWriter.write(endDay);
        predictFileWriter.write(",");
        predictFileWriter.write(toPredict);
        predictFileWriter.close();
        String trainFilePath = "C:\\Users\\ddune\\Documents\\Project1DataTrain.arff";
        BufferedReader trainingReader = null;
        trainingReader = new BufferedReader(new FileReader(trainFilePath));
        Instances train = new Instances(trainingReader);
        train.setClassIndex(train.numAttributes()-1);
        trainingReader.close();
        
        trainingReader = new BufferedReader(new FileReader(predictFilePath));
        Instances test = new Instances(trainingReader);
        test.setClassIndex(train.numAttributes()-1);
        trainingReader.close();
        
        J48 tree = new J48();
        tree.buildClassifier(train);
        Instances labelled = new Instances(test);
        
        int instanceCount = test.numInstances();
        for(int i = 0; i < instanceCount; i++) {
            double classLabel = tree.classifyInstance(test.instance(i));
            labelled.instance(i).setClassValue(classLabel);
        }
        String output = labelled.lastInstance().toString();
        String[] arr = output.split(",");
        
        PreparedStatement ps = (PreparedStatement) conn.prepareStatement(statement);
        UUID uuid = UUID.randomUUID();
        ps.setString(1, uuid.toString());
        ps.setString(2, arr[0]);
        ps.setString(3, arr[1]);
        ps.setString(4, arr[2]);
        ps.setString(5, arr[3]);
        ps.setBoolean(6, Boolean.valueOf(arr[4]));
        ps.executeUpdate();
        int len = arr.length;
        String result = arr[len-1];
        session.setAttribute("ID", uuid.toString());

    } catch (Exception e) {
        e.printStackTrace();
    }
    response.sendRedirect("prediction_output.jsp");
    %>
