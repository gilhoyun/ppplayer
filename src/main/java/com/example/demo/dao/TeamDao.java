package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.dto.Article;
import com.example.demo.dto.Board;
import com.example.demo.dto.Member;
import com.example.demo.dto.Team;
import com.example.demo.dto.TeamRanking;

@Mapper
public interface TeamDao {

	@Insert("""
		    INSERT INTO team
		        SET teamName = #{teamName},
		            region = #{region},
		            slogan = #{slogan},
		            teamImage = #{encodedImage},
		            createdBy = #{createdBy},
		            teamLeader = #{createdBy}, 
		            regDate = NOW(),
		            updateDate = NOW()
		""")
		void joinTeam(String teamName, String region, String slogan, String encodedImage, Integer createdBy);

	@Select("""
			SELECT *
			FROM `team`
			WHERE teamName = #{teamName}
			""")
	Team getTeamByTeamName(String teamName);

	@Select("""
			    SELECT *
			    FROM `team`
			    WHERE createdBy = #{createdBy}
			""")
	List<Team> getTeamsByCreatedBy(Integer createdBy);

	@Select("""
		    SELECT COUNT(*)
		    FROM `team`
		    WHERE createdBy = #{memberId}
		    """)
		int countTeamByMemberId(int memberId);

	
	@Select("""
			<script>
			SELECT t.*, m.loginId as teamLeaderLoginId
			FROM team t
			JOIN member m ON t.teamLeader = m.id
			WHERE 1=1
			<if test="searchKeyword != ''">
			 <if test="searchType == 'teamName'">
			    AND t.teamName LIKE CONCAT('%', #{searchKeyword}, '%')
			 </if>
			 <if test="searchType == 'teamLeader'">
			    AND m.loginId LIKE CONCAT('%', #{searchKeyword}, '%')
			 </if>
			 </if>
			ORDER BY t.id DESC
			LIMIT #{limitFrom}, 10
			</script>
			""")
			List<Team> getTeams(int limitFrom, String searchType, String searchKeyword);

			@Select("""
			<script>
			SELECT COUNT(*)
			FROM team t
			JOIN member m ON t.teamLeader = m.id
			WHERE 1=1
			<if test="searchKeyword != ''">
			 <if test="searchType == 'teamName'">
			   AND t.teamName LIKE CONCAT('%', #{searchKeyword}, '%')
			 </if>
			 <if test="searchType == 'teamLeader'">
			   AND m.loginId LIKE CONCAT('%', #{searchKeyword}, '%')
			 </if>
			</if>
			</script>
			""")
			int teamsCnt(String searchType, String searchKeyword);

			@Select("""
				    SELECT t.*, m.loginId as teamLeaderLoginId
				    FROM team t
				    JOIN member m ON t.teamLeader = m.id
				    WHERE t.id = #{id}
				    """)
		  Team getTeambyId(int id);

			
		@Select("""
				UPDATE `team`
				SET views = views + 1
				WHERE id = #{id}
				""")
		void increaseViews(int id);

		@Delete("""
				DELETE FROM `team`
				WHERE teamName = #{teamName}
				""")
		void doDeleteTeam(String teamName);

		@Select("""
				SELECT * 
				FROM `team`
				WHERE id = #{id}
				""")
		Team getTeamById(int id);
	
		@Update("""
			    UPDATE `team`
			    SET updateDate = NOW(),
			        teamName = #{teamName},
			        region = #{region},
			        slogan = #{slogan},
			        teamImage = COALESCE(#{encodedImage}, teamImage)
			    WHERE id = #{id}
			""")
			void doModifyTeam(int id, String teamName, String region, String slogan, String encodedImage);

		
		
		
		@Select("""
			    SELECT wins, draws, losses, points
			    FROM `team`
			    WHERE id = #{teamId}
			""")
			Team getCurrentTeamResults(int teamId);

			@Update("""
			    UPDATE `team`
			    SET wins = #{wins},
			        draws = #{draws},
			        losses = #{losses},
			        points = #{points},
			        updateDate = NOW()
			    WHERE id = #{teamId}
			""")
			void updateTeamResults(int teamId, int wins, int draws, int losses, int points, int loginedMemberId);

			
			
			@Select("""
					SELECT * 
					FROM `team`
					ORDER BY points DESC, wins DESC, id ASC
					""")
			List<Team> getRankedTeams();
		
		
			
		


}
