var isMaster = rs.isMaster();
var me = isMaster.me;

if(isMaster.ismaster){
    print(me + ' is master');
    db1 = db.getSiblingDB('future');
    db2 = db.getSiblingDB('insight');
    db3 = db.getSiblingDB('keystone');
    db4 = db.getSiblingDB('bo');

    print(' create user test in bo DB');
    db4.createUser(
        {
            user: "bo_admin",
            pwd: "56795c3ba4b4cb0e131cf588c512e244",
            roles: [{
                role: "dbOwner",
                db: "bo"
            }],
            passwordDigestor: "server"
        });
    
    print(' create user test in keystone DB');
    db3.createUser(
        {
            user: "keystone_admin",
            pwd: "56795c3ba4b4cb0e131cf588c512e244",
            roles: [{
                role: "dbOwner",
                db: "keystone"
            }],
            passwordDigestor: "server"
        });
    print(' create user db_admin in Future DB');
    db1.createUser(
        {
            user: "future_admin",
            pwd: "56795c3ba4b4cb0e131cf588c512e244",
            roles: [{
                role: "dbOwner",
                db: "future"
            }],
            passwordDigestor: "server"
            });
    print(' create user db_admin in Insight DB');
    db2.createUser(
        {
            user: "insight_admin",
            pwd: "56795c3ba4b4cb0e131cf588c512e244",
            roles: [{
                role: "dbOwner",
                db: "insight"
            }],
            passwordDigestor: "server"
        });
    print('DONE');
}
