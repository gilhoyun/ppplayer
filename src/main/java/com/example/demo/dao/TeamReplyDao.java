package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.dto.Article;
import com.example.demo.dto.Board;
import com.example.demo.dto.Reply;
import com.example.demo.dto.TeamReply;

@Mapper
public interface TeamReplyDao {

    @Insert("""
        INSERT INTO teamReply
            SET regDate = NOW(),
                updateDate = NOW(),
                memberId = #{memberId},
                relId = #{relId},
                body = #{body}
    """)
    void replyWrite(int memberId, String body, int relId);
    
    @Select("""
        SELECT r.*, m.loginId
        FROM teamReply AS r
        INNER JOIN member AS m
            ON r.memberId = m.id
        WHERE r.relId = #{relId}
    """)
    List<TeamReply> getReplies(int relId);
    
    @Update("""
        UPDATE teamReply
        SET updateDate = NOW(),
            body = #{body}
        WHERE id = #{id}
    """)
    void modifyReply(int id, String body);
    
    @Delete("""
        DELETE FROM teamReply
        WHERE id = #{id}
    """)
    void deleteReply(int id);
}
