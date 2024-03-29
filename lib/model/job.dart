// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Job {
  String? jobId;
  String? jobTitle;
  String? jobDesc;
  String? jobResp;
  String? jobExp;
  String? jobTime;
  String? jobType;
  List? skills;
  String? username;
  String? uid;
  List? applicants;
  DateTime? addDate;
  DateTime? expiryDate;
  bool verified;
  bool expired;
  Job(
      {this.jobId,
      this.jobTitle,
      this.jobDesc,
      this.jobResp,
      this.jobExp,
      this.jobTime,
      this.jobType,
      this.skills,
      this.username,
      this.verified = false,
      this.uid,
      this.applicants,
      this.addDate,
      this.expiryDate,
      this.expired = false});

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'jobTitle': jobTitle,
      'jobDesc': jobDesc,
      'jobResp': jobResp,
      'jobExp': jobExp,
      'jobTime': jobTime,
      'jobType': jobType,
      'skills': skills,
      'verified': verified,
      'username': username,
      'uid': uid,
      'applicants': applicants,
      'addDate': addDate,
      'expiryDate': expiryDate,
      'expired': expired,
    };
  }
}
