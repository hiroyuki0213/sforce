public without sharing class getIndex {
    
    public List<selectoption> selectList {get;set;}
    public List<selectoption> selectJapList {get;set;}
    public String optionVal {get;set;}
    public String reVal {get;set;}
    public List<viewVal> viewList {get;set;}
    public viewVal objectInfo {get;set;}
    
    public getIndex() {
        Map<String, Schema.SObjectType> sMap = Schema.getGlobalDescribe();

        this.selectList = new List<selectoption>();
        this.selectJapList = new List<selectoption>();
        
        for (String objName : smap.keySet()) {
           string objLabel = sMap.get(objName).getDescribe().getLabel();
           this.selectList.add(new Selectoption(objName,objName + '：' + objLabel));
           this.selectJapList.add(new Selectoption(objName, objLabel+ '：' + objName));
        }
        this.selectList.sort();
        this.selectJapList.sort();
   
    }
    
    private string getObjName(Map<string,string> japMap,Map<string,string> engMap,string key) {
        integer flg = 0;
        if (japMap.containsKey(key)) {
            return japMap.get(key);
        } else if(engMap.containsKey(key)){
             return engMap.get(key);
        } else {
            return null;
        }
    }
    
    public void getField() {
        String param = System.currentPageReference().getParameters().get('val');
        Map<String, Schema.SObjectType> sMap = Schema.getGlobalDescribe();
        
        Map<string,string> japMap = new Map<String,string>();
        Map<string,string> engMap = new Map<string,string>();
        
        for (String objName : smap.keySet()) {
           string objLabel = sMap.get(objName).getDescribe().getLabel();
           japMap.put(objLabel,objName );
           engMap.put(objName,objName);
        }
        
        string targetObj = getObjName(japMap,engMap,param);
        
        if (targetObj != null) {
            Schema.SObjectType sObj = sMap.get(targetObj );
            Schema.DescribeSObjectResult result = sObj.getDescribe();
            Map<String, Schema.SObjectField> fmap = result.fields.getMap();
           
            this.objectInfo = new viewVal(
            isCustom(String.valueof(result.iscustom())),
            result.getName(),
            result.getLabel(),
            '',
            ''
            );
    
            this.viewList = new List<viewVal>();
            // 標準項目が上
            for (String str : fmap.KeySet()) {
                 Schema.SObjectField f = fmap.get(str);
                Schema.DescribeFieldResult fr = f.getDescribe();
                if (!fr.iscustom()) {
                     viewVal viewItem = new viewVal(
                     isCustom(String.valueof(fr.iscustom())),
                     fr.getName(),
                     fr.getLabel(),
                     isReference(fr),
                     String.valueof(fr.getLength())
                     );
                     this.viewList.add(viewItem);
                 }
             }
             
             //カスタム項目が下
             for (String str : fmap.KeySet()) {
                 Schema.SObjectField f = fmap.get(str);
                 Schema.DescribeFieldResult fr = f.getDescribe();
                if (fr.iscustom()) {     
                     viewVal viewItem = new viewVal(
                     isCustom(String.valueof(fr.iscustom())),
                     fr.getName(),
                     fr.getLabel(),
                     isReference(fr),
                     String.valueof(fr.getLength())
                     );
                     this.viewList.add(viewItem);
                 }
             }
         }
    }
    
    public without sharing class viewVal {
        public string name {get;set;}
        public string label {get;set;}
        public string type {get;set;}
        public string length {get;set;}
        public string isCustom {get;set;}
        public viewVal(String isCustom,String name,String label,String type,String length) {
            this.isCustom = iscustom;
            this.name = name;
            this.label = label;
            this.type = type;
            this.length = length;
        }
    }
    
    private string isCustom(String key) {    
       if (key == 'true') {
           return 'カスタム';
       } else {
           return '標準';
       }
    }
    
    private String isReference(Schema.DescribeFieldResult key) {
         map<string,string> japMap = new map<string,string>();
         japMap.put('PHONE','電話');
         japMap.put('STRING','テキスト');
         japMap.put('REFERENCE','参照関係');
         japMap.put('PICKLIST','選択リスト');
         japMap.put('TEXTAREA','テキストエリア');
         japMap.put('BOOLEAN','チェックボックス');
          japMap.put('DATETIME','日付時間');
            japMap.put('DATE','日付');
           japMap.put('INTEGER','数値');
            japMap.put('ID','ID');
             japMap.put('DOUBLE','数値');
              japMap.put('CURRENCY','通貨');
               japMap.put('URL','URL');
                japMap.put('DOUBLE','数値');
                
         string stringKey = string.valueof(key.getType());
         if (japMap.containskey(stringKey)) {
           return japMap.get(stringKey);
       } else {
           return stringKey;
       }
    }
    
}