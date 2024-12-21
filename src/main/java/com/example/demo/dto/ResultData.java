package com.example.demo.dto;

import lombok.Data;

@Data //getter, setter 등.......
public class ResultData<DT> {
	private String resultCode;
	private String resultMsg;
	private DT data;
	
	public static <DT> ResultData<DT> from(String resultCode, String resultMsg) {  // 인자를 두개만 받고 있을 때 null이 없는 결과를 만들고 싶을 때
		return from(resultCode, resultMsg, null);
	}
	
	public static <DT> ResultData<DT> from(String resultCode, String resultMsg, DT data) {  //생성자로도 가능
		
		ResultData<DT> rd = new ResultData<>();
		
		rd.resultCode = resultCode;
		rd.resultMsg = resultMsg;
		rd.data = data;
		
		return rd;
	}
	
	public boolean isSuccess() {
		return this.resultCode.startsWith("S-");
	}
	
	public boolean isFail() {
		return isSuccess() == false;
	}
}
