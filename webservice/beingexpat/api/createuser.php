<?php

//creating response array
$response = array();

if($_SERVER['REQUEST_METHOD']=='POST'){

    //getting values
    $name = $_POST['name'];
    $email = $_POST['email'];

    //including the db operation file
    require_once '../includes/DbOperation.php';

    $db = new DbOperation();


    if($db->createUser($name,$email)){
        if($db->createUser($name,$email) == "no"){
            $response['error']=false;
            $response['message']='User already exists';
        }else{
            $response['error']=false;
            $response['message']='User added successfully';
        }

    }else{

        $response['error']=true;
        $response['message']='Could not add user';
    }

}else{
    $response['error']=true;
    $response['message']='You are not authorized';
}
echo json_encode($response);
