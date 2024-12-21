package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.dto.Article;
import com.example.demo.dto.Member;

@Mapper
public interface MemberDao {
	@Insert("""
		    INSERT INTO `member`
		        SET regDate = NOW()
		            , updateDate = NOW()
		            , loginId = #{loginId}
		            , loginPw = #{loginPw}
		            , name = #{name}
		            , email = #{email}
		            , profileImage = #{profileImage}
		    """)
		void joinMember(String loginId, String loginPw, String name, String email, byte[] profileImage);

	@Select("""
			SELECT *
				FROM `member`
				WHERE loginId = #{loginID}
			""")
	Member getMemberByLoginId(String loginId);
	@Select("""
			SELECT *
				FROM `member`
				WHERE id = #{id}
			""")
	Member getMemberById(int id);
	@Select("""
			SELECT LAST_INSERT_ID();
			""")
	int getLastInsertId();
	
	@Update("""
			UPDATE `member`
				SET updateDate = NOW()
					, loginPw = #{loginPw}
				WHERE id = #{loginedMemberId}
			""")
	void modifyPassword(int loginedMemberId, String loginPw);
	
	
	@Select("""
			SELECT *
				FROM `member`
				WHERE `name` = #{name}
				AND email = #{email}
			""")
	Member getMemberByNameAndEmail(String name, String email);

	
}