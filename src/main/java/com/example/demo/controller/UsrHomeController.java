package com.example.demo.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.ResultData;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class UsrHomeController {

    @GetMapping("/usr/home/main")
    public String showMain(Model model, @RequestParam(defaultValue = "1") int page) {
    	 try {
 	        StringBuilder urlBuilder = new StringBuilder("http://openapi.seoul.go.kr:8088");
 	        urlBuilder.append("/" + URLEncoder.encode("6779454974676f6834334550777359", "UTF-8")); /* 인증키 */
 	        urlBuilder.append("/" + URLEncoder.encode("json", "UTF-8")); /* 요청파일타입 */
 	        urlBuilder.append("/" + URLEncoder.encode("ListPublicReservationSport", "UTF-8")); /* 서비스명 */
 	        urlBuilder.append("/" + URLEncoder.encode("1", "UTF-8")); /* 요청시작위치 */
 	        urlBuilder.append("/" + URLEncoder.encode("40", "UTF-8")); /* 요청종료위치 */
 	        urlBuilder.append("/" + URLEncoder.encode("풋살장", "UTF-8"));

 	        URL url = new URL(urlBuilder.toString());
 	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
 	        conn.setRequestMethod("GET");
 	        conn.setRequestProperty("Content-type", "application/json");

 	        BufferedReader rd;
 	        if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
 	            rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
 	        } else {
 	            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
 	        }

 	        StringBuilder sb = new StringBuilder();
 	        String line;
 	        while ((line = rd.readLine()) != null) {
 	            sb.append(line);
 	        }
 	        rd.close();
 	        conn.disconnect();

 	        // Parse JSON and extract reservation details
 	        ObjectMapper objectMapper = new ObjectMapper();
 	        JsonNode rootNode = objectMapper.readTree(sb.toString());
 	        JsonNode rowsNode = rootNode.path("ListPublicReservationSport").path("row");

 	        List<Map<String, String>> reservations = new ArrayList<>();
 	        for (JsonNode node : rowsNode) {
 	            Map<String, String> reservation = new HashMap<>();
 	            reservation.put("placeName", node.path("PLACENM").asText());
 	            reservation.put("url", node.path("SVCURL").asText());
 	            reservation.put("startDate", node.path("RCPTBGNDT").asText());
 	            reservation.put("endDate", node.path("RCPTENDDT").asText());
 	            reservation.put("imgUrl", node.path("IMGURL").asText());
 	            reservation.put("startTime", node.path("V_MIN").asText());
 	            reservation.put("endTime", node.path("V_MAX").asText());
 	            reservation.put("paymentMethod", node.path("PAYATNM").asText());
 	            reservation.put("serviceStatus", node.path("SVCSTATNM").asText());
 	            reservation.put("useTgtInfo", node.path("USETGTINFO").asText());

 	            reservations.add(reservation);
 	        }

 	        // Pagination logic
 	        int totalItems = reservations.size();
 	        int itemsPerPage = 6;
 	        int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
 	        int startIndex = (page - 1) * itemsPerPage;
 	        int endIndex = Math.min(startIndex + itemsPerPage, totalItems);

 	        // Ensure the sublist indices are valid
 	        if (startIndex >= totalItems) {
 	            startIndex = totalItems;  // If startIndex is beyond the totalItems, set it to totalItems
 	        }

 	        if (startIndex < endIndex) {
 	            List<Map<String, String>> paginatedReservations = reservations.subList(startIndex, endIndex);
 	            model.addAttribute("reservations", paginatedReservations);
 	        } else {
 	            model.addAttribute("reservations", new ArrayList<>());  // Return an empty list if invalid range
 	        }

 	        // Pagination page range calculation (5 pages at a time)
 	        int fromPage = Math.max(1, (page - 1) / 5 * 5 + 1); // Ensure fromPage starts at 1
 	        int toPage = Math.min(fromPage + 4, totalPages);

 	        model.addAttribute("page", page);
 	        model.addAttribute("totalPages", totalPages);
 	        model.addAttribute("fromPage", fromPage);
 	        model.addAttribute("toPage", toPage);

 	        return "usr/home/main";
 	    } catch (Exception e) {
 	        e.printStackTrace();
 	        model.addAttribute("errorMessage", "API 호출 중 오류가 발생했습니다: " + e.getMessage());
 	        return "usr/home/main";
 	    }
    }

    @GetMapping("/")
    public String showRoot() {
        return "redirect:/usr/home/main";
    }

    @GetMapping("/usr/home/test")
    @ResponseBody
    public ResultData<Map<String, Object>> test(String key1, String key2) {
        Map<String, Object> map = new HashMap<>();
        map.put("key1", key1);
        map.put("key2", key2);

        return ResultData.from("code", key1 + key2, map);
    }

    @GetMapping("/usr/home/publicData")
    public String publicDataPage(Model model) {
        return "usr/home/publicData";
    }
}