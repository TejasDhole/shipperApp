
class CompanyModel{
  //c_name -- > company_name , c_cin --> company_corporate identifier number
  String? c_uuid, c_name, c_email, c_website, c_address, c_city, c_state, c_gst, c_cin, c_pinCode, c_phnNo;
  List? members;
  List? transporters = [];

  CompanyModel(this.c_name, this.c_email, this.c_address, this.c_website, this.c_city, this.c_state, this.c_gst, this.c_cin, this.c_pinCode, this.c_phnNo, this.c_uuid, this.members, this.transporters);


  Map<String, dynamic> toJson(){
    Map<String, dynamic> company_details = {};

    if(c_name !=null){
      company_details['company_name'] = c_name;
    }
    if(c_gst!=null){
      company_details['gst_no'] = c_gst;
    }
    if(c_cin !=null){
      company_details['cin'] = c_cin;
    }

    Map<String, dynamic> contact_info = {};

    if(c_email!=null){
      contact_info['company_email'] = c_email;
    }
    if(c_phnNo != null){
      contact_info['company_phone'] = c_phnNo;
    }
    if(c_website != null){
      contact_info['company_website'] = c_website;
    }

    if(contact_info !=null) {
      company_details['contact_info'] = contact_info;
    }

    Map<String, dynamic> company_address = {};

    if(c_address!=null){
      company_address['company_address'] = c_address;
    }
    if(c_city!=null){
      company_address['company_city'] = c_city;
    }
    if(c_state!=null){
      company_address['company_state'] = c_state;
    }
    if(c_pinCode!=null){
      company_address['company_pinCode'] = c_pinCode;
    }

    if(company_address!=null){
      company_details['company_address'] = company_address;
    }

    Map<String, dynamic> companyDoc = {};

    if(c_uuid != null){
      companyDoc['company_uuid'] = c_uuid;
    }

    if(company_details!=null){
        companyDoc['company_details'] = company_details;
    }

    if(members!=null){
      companyDoc['members'] = members;
    }

    if(transporters!=null){
      companyDoc['members'] = transporters;
    }

    return companyDoc;

  }
}