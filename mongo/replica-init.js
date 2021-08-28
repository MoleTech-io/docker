const config = {
    _id: "main",
    members: [
      { _id: 0, host: "mongodb1:25015" },
      { _id: 1, host: "mongodb2:25016" },
      { _id: 2, host: "mongodb3:25017", arbiterOnly: true },
    ],
  };
rs.initiate(config);
  
