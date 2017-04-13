<?php
class DbOperation
{
    private $conn;

    //Constructor
    function __construct()
    {
        require_once dirname(__FILE__) . '/Config.php';
        require_once dirname(__FILE__) . '/DbConnect.php';
        // opening db connection
        $db = new DbConnect();
        $this->conn = $db->connect();
    }

    //Function to create a new user
    public function createUser($name, $email)
    {

        if($this->checkIfUserExists($email)==false) {
            $stmt = $this->conn->prepare("INSERT INTO user(name,email) values(:name,:email)");
            $stmt->bindParam(":name", $name);
            $stmt->bindParam(":email", $email);
            $result = $stmt->execute();
        }else{
            $result = "no";
        }

        return $result;
    }

    public function checkIfUserExists($email){
        $stmt = $this->conn->prepare("SELECT * FROM user WHERE email = ?");
        $stmt->execute(array($email));
        $rows = $stmt->rowCount();
        var_dump($rows)
            die();
        if($rows < 1){
            return false;
        }else{
            return true;
        }
    }

    public function userConnection($id){

    }

}