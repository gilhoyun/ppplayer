package com.example.demo.service;

import org.springframework.stereotype.Service;

import com.example.demo.dao.LikePointDao;
import com.example.demo.dto.LikePoint;

@Service
public class LikePointService {
	
	private LikePointDao likePointDao;
	
	public LikePointService(LikePointDao likePointDao) {
		this.likePointDao = likePointDao;
	}

	public void insertLikePoint(int loginedMemberId, String relTypeCode, int relId) {
		likePointDao.insertLikePoint(loginedMemberId, relTypeCode, relId);
	}

	public LikePoint getLikePoint(int loginedMemberId, String relTypeCode, int relId) {
		return likePointDao.getLikePoint(loginedMemberId, relTypeCode, relId);
	}

	public void deleteLikePoint(int loginedMemberId, String relTypeCode, int relId) {
		likePointDao.deleteLikePoint(loginedMemberId, relTypeCode, relId);
	}

	public int getLikePointCnt(String relTypeCode, int relId) {
		return likePointDao.getLikePointCnt(relTypeCode, relId);
	}
}
