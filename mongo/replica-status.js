var isMaster = rs.isMaster();
var me = isMaster.me;

if(!isMaster.ismaster && isMaster.secondary){
    var status = rs.status();
    print(JSON.stringify(status.members, null, 2));

}else{
    print(me + ' is not secondary');
}