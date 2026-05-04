<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">

<html>
<head>
  <title>Railway Trip Management</title>

  <style>
    body {
      font-family: Arial, sans-serif;
      background: #fff0f6;
      color: #5a3e4d;
      padding: 20px;
    }

    h1 {
      text-align: center;
      color: #d63384;
      margin-bottom: 30px;
    }

    h2 {
      margin-top: 30px;
      color: #c2255c;
    }

    h3 {
      color: #a61e4d;
      margin-bottom: 8px;
    }

    table {
      border-collapse: collapse;
      width: 60%;
      margin-bottom: 20px;
      background: #ffe3ec;
      border-radius: 10px;
      overflow: hidden;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }

    th, td {
      border: 1px solid #f8bbd0;
      padding: 8px;
      text-align: center;
    }

    th {
      background: #faa2c1;
      color: white;
    }

    td {
      background: #fff5f8;
    }

    tr:hover td {
      background: #ffd6e7;
    }
  </style>

</head>

<body>

<h1>🚆 Railway Trip Management</h1>

<!-- LOOP LINES -->
<xsl:for-each select="transport/lines/line">

  <h2>
    Line <xsl:value-of select="@code"/>
    (
    <xsl:value-of select="/transport/stations/station[@id=current()/@departure]/@name"/>
    →
    <xsl:value-of select="/transport/stations/station[@id=current()/@arrival]/@name"/>
    )
  </h2>

  <!-- LOOP TRIPS -->
  <xsl:for-each select="trips/trip">

    <h3>Trip <xsl:value-of select="@code"/></h3>

    <table>
      <tr>
        <th>Schedule</th>
        <th>Type</th>
        <th>Economy</th>
        <th>VIP</th>
        <th>Days</th>
      </tr>

      <tr>
        <td>
          <xsl:value-of select="schedule/@departure"/>
          →
          <xsl:value-of select="schedule/@arrival"/>
        </td>

        <td>
          <xsl:value-of select="@type"/>
        </td>

        <td>
          <xsl:value-of select="class[@type='Economy']/@price"/> DA
        </td>

        <td>
          <xsl:choose>
            <xsl:when test="class[@type='VIP']">
              <xsl:value-of select="class[@type='VIP']/@price"/> DA
            </xsl:when>
            <xsl:otherwise>-</xsl:otherwise>
          </xsl:choose>
        </td>

        <td>
          <xsl:value-of select="days"/>
        </td>
      </tr>

    </table>

  </xsl:for-each>

</xsl:for-each>

</body>
</html>

</xsl:template>

</xsl:stylesheet>