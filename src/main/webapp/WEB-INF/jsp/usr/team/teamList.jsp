<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<c:set var="pageTitle" value="팀 찾기" />

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<section class="py-8 ">
    <div class="max-w-4xl mx-auto p-6 bg-white rounded-lg shadow-md relative">
        <h2 class="text-2xl font-semibold text-gray-800 mb-6">팀 찾기</h2>
        
        <!-- Existing search form -->
        <div class="w-full mx-auto mb-2 flex justify-between items-center text-sm">
            <div class="flex items-center">총: ${teamsCnt}개</div>
            <form class="flex items-center">
                <select class="select select-bordered select-sm mr-2" name="searchType">
                    <option value="teamName" <c:if test="${searchType == 'teamName' }">selected="selected"</c:if>>팀명</option>
                    <option value="teamLeader" <c:if test="${searchType == 'teamLeader' }">selected="selected"</c:if>>팀장</option>
                </select>
                <label class="input input-bordered input-sm flex items-center gap-2 w-60">
                    <input type="text" class="grow" name="searchKeyword" 
                           placeholder="검색어를 입력해주세요" maxlength="25" value="${searchKeyword }" />
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="h-4 w-4 opacity-70">
                        <path fill-rule="evenodd" d="M9.965 11.026a5 5 0 1 1 1.06-1.06l2.755 2.754a.75.75 0 1 1-1.06 1.06l-2.755-2.754ZM10.5 7a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0Z" clip-rule="evenodd" />
                    </svg>
                </label>
                <button type="submit" class="hidden">검색</button>
            </form>
        </div>

        <table class="w-full text-left border-collapse ">
            <thead>
                <tr class="border-b ">
                    <th class="text-center p-4 font-medium text-gray-700 bg-gray-100">번호</th>
                    <th class="text-center p-4 font-medium text-gray-700 bg-gray-100">팀명</th>
                    <th class="text-center p-4 font-medium text-gray-700 bg-gray-100">팀장</th>
                    <th class="text-center p-4 font-medium text-gray-700 bg-gray-100">창단일</th>
                    <th class="text-center p-4 font-medium text-gray-700 bg-gray-100">조회수</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="team" items="${teams}">
                    <tr class="border-b">
                        <td class="text-center p-4">${team.getId()}</td>
                        <td class="hover:underline text-center p-4">
                            <a href="detail?id=${team.getId()}">${team.getTeamName()}</a>
                        </td>
                        <td class="text-center p-4">${team.getTeamLeaderLoginId()}</td>
                        <td class="text-center p-4">${team.getRegDate().substring(2,16)}</td>
                        <td class="text-center p-4">${team.getViews()}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Pagination remains the same -->
        <div class="mt-3 flex justify-between items-center">
            <div class="flex-grow flex justify-center">
                <div class="join">
                    <c:set var="path" value="searchType=${searchType }&searchKeyword=${searchKeyword }" />

                    <c:if test="${from != 1}">
                        <a href="${path }&cPage=1" class="join-item btn"><<</a>
                        <a href="${path }&page=${from - 1}" class="join-item btn"><</a>
                    </c:if>

                    <c:forEach var="i" begin="${from }" end="${end }">
                        <a href="${path }&page=${i}" 
                           class="join-item btn btn-square ${page == i ? 'btn-active' : ''}" 
                           type="radio" name="options" />${i }</a>
                    </c:forEach>

                    <c:if test="${end != totalPagesCnt }">
                        <a href="${path }&page=${end + 1}" class="join-item btn">></a>
                        <a href="${path }&page=${totalPagesCnt }" class="join-item btn">>></a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>