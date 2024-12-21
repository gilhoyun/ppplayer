package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.dto.Article;
import com.example.demo.dto.Board;

@Mapper
public interface ArticleDao {

	Article getLastInsertArticle = null;

	@Insert("""
			 INSERT INTO article
			     SET regDate = NOW()
			     , updateDate = NOW()
			     , boardId = #{boardId}
			     , memberId =#{loginedMemberId}
			     , title = #{title}
			     , `body` = #{body}
			""")
	public void writeArticle(int loginedMemberId, int boardId, String title, String body);

	@Select("""
			<script>
			SELECT a.*
					, m.loginId
					, IFNULL(SUM(l.point), 0) AS `like`
				FROM article AS a
				INNER JOIN `member` AS m
				ON a.memberId = m.id
				LEFT JOIN likePoint AS l
				ON l.relTypeCode = 'article'
				AND l.relId = a.id
				WHERE a.boardId = #{boardId}
				<if test="searchKeyword != ''">
					<choose>
						<when test="searchType == 'title'">
							AND a.title LIKE CONCAT('%', #{searchKeyword}, '%')
						</when>
						<when test="searchType == 'body'">
							AND a.body LIKE CONCAT('%', #{searchKeyword}, '%')
						</when>
						<otherwise>
							AND (
								a.title LIKE CONCAT('%', #{searchKeyword}, '%')
								OR a.body LIKE CONCAT('%', #{searchKeyword}, '%')
							) 
						</otherwise>
					</choose>
				</if>
				GROUP BY a.id
				ORDER BY a.id DESC
				LIMIT #{limitFrom}, 10
			</script>
			""")
	public List<Article> getArticles(int boardId, int limitFrom, String searchType, String searchKeyword);

	@Select("""
			SELECT article.*, `member`.loginId
			FROM article
			INNER JOIN `member`
			ON article.memberid = `member`.id
			WHERE article.id = #{id}
			""")
	public Article getArticlebyId(int id);

	@Update("""
			<script>
			UPDATE article
			       SET updateDate = Now()
			          ,title = #{title}
			          ,`body` = #{body}
			       WHERE id = #{id}
			</script>
			""")
	public void doModify(int id, String title, String body);

	@Delete("""
			DELETE FROM article
			WHERE id = #{id}
			""")
	public void doDelete(int id);

	@Select("""
			SELECT LAST_INSERT_ID();
			""")
	public int getLastInsertId();

	@Select("""
			SELECT * FROM board
			WHERE id= #{boardId}
			""")
	public Board getBoardId(int boardId);

	@Select("""
			<script>
			SELECT COUNT(*)
				FROM article
				WHERE boardId = #{boardId}
				<if test="searchKeyword != ''">
					<choose>
						<when test="searchType == 'title'">
							AND title LIKE CONCAT('%', #{searchKeyword}, '%')
						</when>
						<when test="searchType == 'body'">
							AND `body` LIKE CONCAT('%', #{searchKeyword}, '%')
						</when>
						<otherwise>
							AND (
								title LIKE CONCAT('%', #{searchKeyword}, '%')
								OR `body` LIKE CONCAT('%', #{searchKeyword}, '%')
							)
						</otherwise>
					</choose>
				</if>
			</script>
			""")
	public int articlesCnt(int boardId, String searchType, String searchKeyword);

	@Update("""
			UPDATE article
				SET views = views + 1
				WHERE id = #{id}		
			""")
	public void increaseViews(int id);

}
