package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.dto.Article;
import com.example.demo.dto.Board;
import com.example.demo.dto.TeamMember;

@Mapper
public interface TeamMemberDao {

	@Insert("""
	        INSERT INTO team_member 
	        SET teamId = #{teamId}, 
	            memberId = #{memberId}, 
	            ROLE = 'MEMBER', 
	            STATUS = 'PENDING',
	            regDate = NOW(),
	            updateDate = NOW()
	    """)
	void requestJoin(int teamId, Integer memberId);

	@Select("""
	        SELECT tm.id, tm.memberId, m.name AS memberName, tm.regDate
	        FROM team_member tm
	        JOIN member m ON tm.memberId = m.id
	        WHERE tm.teamId = #{teamId} AND tm.status = 'PENDING'
	    """)
	List<TeamMember> getPendingRequestsByTeamId(int id);

	@Update("""
	        UPDATE team_member 
	        SET STATUS = 'APPROVED', 
	            updateDate = NOW() 
	        WHERE id = #{teamMemberId}
	    """)
	void approveMember(int teamMemberId);

	@Update("""
	        UPDATE team_member 
	        SET STATUS = 'REJECTED', 
	            updateDate = NOW() 
	        WHERE id = #{teamMemberId}
	    """)
	void rejectMember(int teamMemberId);

	 @Select("""
		        SELECT tm.id, tm.memberId, m.name AS memberName, tm.regDate, tm.role
		        FROM team_member tm
		        JOIN member m ON tm.memberId = m.id
		        WHERE tm.teamId = #{teamId} AND tm.status = 'APPROVED'
		    """)
	List<TeamMember> getApprovedMembersByTeamId(int id);

	 
	 @Select("""
		        SELECT COUNT(*) > 0
		        FROM team_member
		        WHERE memberId = #{loginedMemberId} AND STATUS = 'APPROVED'
		    """)
    boolean isUserMemberOfAnyTeam(int loginedMemberId);

	 
	 @Select("""
			    SELECT tm.id, tm.teamId, tm.memberId, m.name AS memberName, tm.regDate, tm.role
			    FROM team_member tm
			    JOIN member m ON tm.memberId = m.id
			    WHERE tm.memberId = #{memberId} AND tm.status = 'APPROVED'
			""")
	List<TeamMember> getApprovedTeamsByMemberId(Integer loginedMemberId);

	 @Delete("""
	 		DELETE FROM team_member
			WHERE memberId = #{memberId}
	 		""")
	void doDelete(int memberId);


}
